#!/bin/bash
set -e
exec > /var/log/provision.log 2>&1
export DEBIAN_FRONTEND=noninteractive

# 1. Install prerequisites
apt-get update
apt-get install -y ca-certificates curl gnupg apache2-utils sqlite3 nginx openssl

# 2. Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 3. Prepare volumes and database
mkdir -p /etc/open-webui.d
USER="admin@demo.gs"
PASSWD=$(htpasswd -bnBC 10 "" "mypassword" | tr -d ':\n')

docker pull ghcr.io/open-webui/open-webui:ollama
docker run -d -p 8080:8080 \
  -v /etc/open-webui.d:/root/.open_web_ui \
  -v /etc/open-webui.d:/app/backend/data \
  --name openwebui-init ghcr.io/open-webui/open-webui:ollama

# Wait for DB to be generated
timeout 120 bash -c 'while [[ "$(curl -s -o /dev/null -w "%%{http_code}" http://localhost:8080)" != "200" ]]; do sleep 5; done' || true
docker stop openwebui-init
docker rm openwebui-init

cat <<EOF > /etc/open-webui.d/webui.sql
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
INSERT INTO auth VALUES('488af2d3-dd38-4310-a549-6d8ad11ae69e','$USER','$PASSWD',1);
INSERT INTO user VALUES('488af2d3-dd38-4310-a549-6d8ad11ae69e','Admin User','$USER','admin','avatar',NULL,1719901984,1719901984,1719901984,'null','null',NULL);
COMMIT;
EOF

sqlite3 /etc/open-webui.d/webui.db < /etc/open-webui.d/webui.sql

# 4. Generate self-signed cert
mkdir -p /etc/nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/certs/selfsigned.key \
  -out /etc/nginx/certs/selfsigned.crt \
  -subj "/CN=$(curl -s ifconfig.me)"

# 5. Configure NGINX for reverse proxy
cat << 'EOF' > /etc/nginx/sites-available/openwebui
server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/nginx/certs/selfsigned.crt;
    ssl_certificate_key /etc/nginx/certs/selfsigned.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

server {
    listen 80;
    return 301 https://$host$request_uri;
}
EOF

ln -sf /etc/nginx/sites-available/openwebui /etc/nginx/sites-enabled/openwebui
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx

# 6. Set up OpenWebUI systemd service
cat << 'EOF' > /etc/systemd/system/openwebui.service
[Unit]
Description=Open Web UI Service
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker rm -f openwebui
ExecStart=/usr/bin/docker run --name openwebui \
  -p 8080:8080 \
  -e RAG_EMBEDDING_MODEL_AUTO_UPDATE=true \
  -v /etc/open-webui.d:/root/.open_web_ui \
  -v /etc/open-webui.d:/app/backend/data \
  ghcr.io/open-webui/open-webui:ollama

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now openwebui.service

echo "✅ Open Web UI is ready at: https://$(curl -s ifconfig.me)"
