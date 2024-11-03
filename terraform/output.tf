output "building_web_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.buildindg_web.id
}

output "building_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.buildindg_web.public_ip
}