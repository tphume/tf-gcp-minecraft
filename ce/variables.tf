variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region to create resource in"
  type        = string
}

variable "ce" {
  description = "Name to be used for Compute Engine instance"
  type        = string
}