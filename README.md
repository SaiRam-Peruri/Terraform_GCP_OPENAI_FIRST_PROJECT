# 🚀 Deploy Open Web UI on GCP with Terraform

This Terraform module provisions a Google Cloud Platform (GCP) virtual machine and installs **[Open Web UI](https://github.com/open-webui/open-webui)** using Docker. It supports optional GPU acceleration and integrates with the OpenAI API.

---

## 📦 Features

- ✅ Supports both **CPU** and **GPU**-enabled VM types  
- 🔐 Generates a secure random admin password  
- 🐳 Installs and configures Docker and Open Web UI  
- 🔑 Sets up SSH and HTTP firewall rules  
- 🌐 Optionally connects to OpenAI API for extended functionality  
- ☁️ Uses a custom GCP service account and startup provisioning script  

---

## 📋 Prerequisites

- Terraform ≥ 1.4.0  
- GCP account with billing enabled  
- GCP project and service account with the following roles:  
  - `Compute Admin`  
  - `Service Account User`  
  - `Storage Admin` (if needed)  
- A valid OpenAI API key (optional)  
- SSH key pair (`id_rsa.pub` for VM login)  

---

## 📁 File Structure

```plaintext
.
├── main.tf                    # Terraform resources
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── providers.tf               # Provider configuration
├── scripts/
    └── provision_basic.sh     # Startup script (called via templatefile)
    └── provision_vars.sh
├── vm.tf 
└── README.md                  # You're here
```

## ⚙️ Setup Instructions

1. 📁 **Clone the Repository**

    ```bash
    git clone https://github.com/YOUR_REPO/openwebui-gcp-terraform.git
    cd openwebui-gcp-terraform
    ```

2. 🔑 **Create or Obtain GCP Credentials**

    - Go to [Google Cloud Console](https://console.cloud.google.com/)
    - Create a service account with the following roles:
        - `Compute Admin`
        - `Service Account User`
    - Generate a JSON key and download it (e.g., `credentials.json`)
    - Save it in the root directory of this repo

3. 📄 **Create `terraform.tfvars`**

    Create a file named `terraform.tfvars` in the root directory with the following values:

    ```hcl
    project_id           = "your-gcp-project-id"
    region               = "us-central1"
    zone                 = "us-central1-a"
    gcp_credentials_file = "./credentials.json"
    openai_key           = "sk-..."                            # Optional: Your OpenAI API Key
    openai_base          = "https://api.openai.com/v1"        # Optional base URL
    gpu_enabled          = true                               # Set to false if no GPU is needed
    ssh_pub_key          = "./id_rsa.pub"                     # Your public SSH key
    ```

    > 🛠️ If you don't have an SSH key yet, generate one:
    >
    > ```bash
    > ssh-keygen -t rsa -b 4096 -f id_rsa
    > ```

4. 📦 **Initialize Terraform**

    ```bash
    terraform init
    ```

5. ✅ **Apply the Terraform Plan**

    ```bash
    terraform apply
    ```

    - Type `yes` when prompted to confirm
    - This will create the VM, configure Docker, set up the firewall, and install Open Web UI
    - On success, Terraform will output:
        - `public_ip`
        - `password` (sensitive)

6. 🌐 **Access the Web UI**

    - Open your browser and visit:
      ```
      http://<public_ip>
      ```
    - Login with:
      - **Username**: `admin@demo.gs`
      - **Password**: (from Terraform output)

7. 🧹 **(Optional) Destroy Resources**

    To clean up everything:

    ```bash
    terraform destroy
    ```

---

