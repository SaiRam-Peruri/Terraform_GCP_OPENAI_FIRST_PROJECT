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
