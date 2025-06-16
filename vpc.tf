resource "google_compute_network" "openwebui_vpc" {
  name                    = "openwebui-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "openwebui_subnet" {
  name          = "openwebui-subnet"
  region        = var.region
  network       = google_compute_network.openwebui_vpc.id
  ip_cidr_range = "10.0.0.0/24"
}

