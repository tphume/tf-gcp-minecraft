provider "google" {
  project = var.project
  region  = var.region
}

// Creates the GKE resource
resource "google_container_cluster" "minecraft" {
  name = var.cluster

  remove_default_node_pool = true
  initial_node_count       = 1
}

// Create the node pool
resource "google_container_node_pool" "minecraft" {
  name       = var.node_pool
  cluster    = google_container_cluster.minecraft.name
  node_count = 1

  node_config {
    disk_size_gb = 10

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}