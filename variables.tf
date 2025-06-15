variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "gcp_credentials_file" {}
variable "vm_name" {
  default = "terraform-gcp-vm"
}

variable "image" {
  default = "debian-cloud/debian-12"
}
variable "ssh_pub_key" {
  default = "id_rsa.pub"
}
