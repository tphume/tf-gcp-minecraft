output "minecraft_server_addr" {
  value = google_compute_address.minecraft.address
  description = "The public ip address of the minecraft server"
}