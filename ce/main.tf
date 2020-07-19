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
    ports    = ["25565"]
  }

  target_tags = ["mc"]

  source_ranges = ["0.0.0.0/0"]
}

// Disk independent from instance for persistence
resource "google_compute_disk" "minecraft" {
  name                      = var.disk
  type                      = "pd-standard"
  image                     = data.google_compute_image.cos.self_link
  physical_block_size_bytes = 4096
}

// Compute Engine instance configuration
resource "google_compute_instance" "minecraft" {
  name         = var.ce
  machine_type = var.mtype

  tags = ["mc"]

  boot_disk {
    source      = google_compute_disk.minecraft.self_link
    auto_delete = false
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.minecraft.address
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  metadata_startup_script = <<EOT
  docker run -d -p 25565:25565 -e VERSION=${var.mc_version} -e MEMORY=6G \
  -e EULA=TRUE -v "$(pwd)"mc:/data \
  --restart always --name mc itzg/minecraft-server
  EOT

  allow_stopping_for_update = true
}
