output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.app.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.app.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.app.public_dns
}

output "security_group_id" {
  description = "ID of the EC2 security group."
  value       = aws_security_group.ec2.id
}

output "generated_key_name" {
  description = "Name of the Terraform-generated EC2 key pair."
  value       = aws_key_pair.ec2.key_name
}

output "generated_private_key_pem" {
  description = "Private SSH key generated for the EC2 instance. Store securely."
  value       = tls_private_key.ec2.private_key_pem
  sensitive   = true
}
