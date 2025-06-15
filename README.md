# 🚀 Deploy Open Web UI on GCP with Terraform

This Terraform module provisions a Google Cloud Platform (GCP) virtual machine and installs **[Open Web UI](https://github.com/open-webui/open-webui)** using Docker. It supports optional GPU acceleration and integrates with the OpenAI API.

---

## 📦 Features

- ✅ Supports both **CPU** and **GPU**-enabled VM types.
- 🔐 Generates a secure random admin password.
- 🐳 Installs and configures Docker and Open Web UI.
- 🔑 Sets up SSH and HTTP firewall rules.
- 🌐 Optionally connects to OpenAI API for extended functionality.
- ☁️ Uses a custom GCP service account and startup provisioning script.

---

## 📋 Prerequisites

- Terraform ≥ 1.4.0
- GCP account with billing enabled
- GCP project and service account with the following roles:
  - `Compute Admin`
  - `Service Account User`
  - `Storage Admin` (if needed)
- A valid OpenAI API key (optional)
- SSH key pair (public key used for VM login)

---

## 📁 File Structure

```plaintext
.
├── main.tf                    # Terraform resources
├── variables.tf              # Input variables
├── outputs.tf                # Output values
├── terraform.tf              # Provider configuration
├── scripts/
│   └── provision_vars.sh     # Startup script (called via templatefile)
└── README.md                 # You're here

⚙️ Setup Instructions
1. 📁 Clone the Repository
bash
Copy
Edit
git clone https://github.com/YOUR_REPO/openwebui-gcp-terraform.git
cd openwebui-gcp-terraform
2. 🔑 Create or Obtain GCP Credentials
Go to Google Cloud Console

Create a service account with roles:

Compute Admin

Service Account User

Generate a JSON key file and download it (e.g., credentials.json)

3. 📄 Create terraform.tfvars
Create a file named terraform.tfvars in the root directory and populate it:

hcl
Copy
Edit
project_id           = "your-gcp-project-id"
region               = "us-central1"
zone                 = "us-central1-a"
gcp_credentials_file = "./credentials.json"
openai_key           = "sk-..."            # Optional: Your OpenAI API Key
openai_base          = "https://api.openai.com/v1"  # Optional base URL
gpu_enabled          = true                # Set to false if no GPU is needed
ssh_pub_key          = "./id_rsa.pub"      # Your public SSH key
🛠️ If you don't have an SSH key yet, generate one with:

bash
Copy
Edit
ssh-keygen -t rsa -b 4096 -f id_rsa
4. 📦 Initialize Terraform
bash
Copy
Edit
terraform init
5. ✅ Apply Terraform Plan
bash
Copy
Edit
terraform apply
Confirm when prompted.

Deployment takes a few minutes (approx. 5–10).

On success, you'll see output values like public_ip and password.

6. 🌐 Access the Web UI
Open your browser and visit:
http://<public_ip> (replace with actual output)

Login with:

Username: admin@demo.gs (default)

Password: from Terraform output (sensitive)
