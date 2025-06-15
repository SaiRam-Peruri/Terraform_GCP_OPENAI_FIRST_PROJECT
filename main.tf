variable "machine" {
  description = "The machine type and image to use for the VM"
  # GPU instance with 24GB of memory and 4 vCPUs with 16GB of system RAM
  default = {
    "gpu" : { "type" : "g2-standard-4", "project" : "click-to-deploy-images", "family" : "common-cu121-debian-11-py310" }
    "cpu" : { "type" : "n1-standard-4", "project" : "debian-cloud", "family" : "debian-11" }
  }
}

variable "gpu_enabled" {
  description = "Is the VM GPU enabled"
  default     = true
}

variable "open_webui_user" {
  description = "Username to access the web UI"
  default     = "admin@demo.gs"
}

variable "openai_base" {
  description = "Optional base URL to use OpenAI API with Open Web UI"
  default     = "https://api.openai.com/v1"
}

variable "openai_key" {
  description = "Optional API key to use OpenAI API with open_web_ui UI"
  default     = ""
}

