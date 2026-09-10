output "instance_id" {
  description = "ID of the Campus Connect EC2 instance"
  value       = aws_instance.campus_connect_server.id
}

output "public_ip" {
  description = "Public IP address of the Campus Connect EC2 instance"
  value       = aws_instance.campus_connect_server.public_ip
}

output "security_group_id" {
  description = "ID of the Campus Connect security group"
  value       = aws_security_group.campus_connect_sg.id
}