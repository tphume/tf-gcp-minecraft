variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region to create resource in"
  type        = string
}

variable "cluster" {
  description = "Name of the Kubernetes cluster to be created"
  type        = string
}

variable "node_pool" {
  description = "Name of the node pool"
  type        = string
}