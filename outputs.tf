output "public_ip" {
  value = resource.google_compute_instance.openwebui.network_interface.0.access_config.0.nat_ip
}

output "password" {
  sensitive   = true
  description = "The password for the Open Web UI user"
  value       = random_password.password.result
}

output "web_ui_url_https" {
  value = "https://${google_compute_instance.openwebui.network_interface[0].access_config[0].nat_ip}"
}
output "web_ui_url_http" {
  value = "http://${google_compute_instance.openwebui.network_interface[0].access_config[0].nat_ip}"
}