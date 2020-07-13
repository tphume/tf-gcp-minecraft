provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

// Get the latest Container-Optimized OS image
data "google_compute_image" "cos" {
  family = "cos-stable"
}

// Static External address for the server
resource "google_compute_address" "minecraft" {
  name         = var.ce
  address_type = "EXTERNAL"
}

// Firewall policy to allow external access to server
resource "google_compute_firewall" "web-server" {
  name    = "web-server"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["mc"]

  source_ranges = ["0.0.0.0/0"]
}

// Compute Engine instance configuration
resource "google_compute_instance" "minecraft" {
  name         = var.ce
  machine_type = "f1-micro"

  tags = ["mc"]

  boot_disk {
    initialize_params {
      type  = "pd-standard"
      image = data.google_compute_image.cos
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.minecraft.address
    }
  }
}