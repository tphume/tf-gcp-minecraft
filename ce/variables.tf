variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region to create resource in"
  type        = string
}

variable "zone" {
  description = "Zone to create resource in"
  type        = string
}

variable "mtype" {
  description = "Type of machine for Compute Engine instance"
  type        = string
}

variable "mc_version" {
  description = "Version of the Minecraft server"
  type        = string
}