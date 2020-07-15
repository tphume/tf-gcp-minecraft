provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

// Get the latest Container-Optimized OS image
data "google_compute_image" "cos" {
  family  = "cos-stable"
  project = "cos-cloud"
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

// Template file setting up the instance
data "template_file" "cloud_init" {
  template = "${file("cloud-init.yml.tpl")}"
  vars = {
    version = var.mc_version
  }
}

// Compute Engine instance configuration
resource "google_compute_instance" "minecraft" {
  name         = var.ce
  machine_type = var.mtype

  tags = ["mc"]

  boot_disk {
    initialize_params {
      type  = "pd-standard"
      image = data.google_compute_image.cos.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.minecraft.address
    }
  }

  metadata {
    user-data = data.template_file.cloud_init.rendered
  }
}