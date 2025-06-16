# Allow SSH (port 22) only from your IP (replace with your actual IP or VPN range)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.openwebui_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["73.17.243.189/32"] # Replace with your IP
  target_tags   = ["ssh"]
}

# Allow HTTP (port 80) for health checks and cert validation
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.openwebui_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

# Allow HTTPS (port 443) for secure web traffic
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.openwebui_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]
}
