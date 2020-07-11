provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

data "google_compute_image" "cos" {
  family = "cos-stable"
}

resource "google_compute_instance" "minecraft" {
  name         = var.ce
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      type  = "pd-standard"
      image = data.google_compute_image.cos
    }
  }
}