variable "aws_region" {
  description = "AWS region in which resources will be created."
  type        = string
}

variable "project_name" {
  description = "Name prefix used for AWS resources."
  type        = string
  default     = "terraform-ec2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Use an AMI available in aws_region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to connect over SSH."
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port exposed for the application."
  type        = number
  default     = 8501
}

variable "tags" {
  description = "Additional tags applied to resources."
  type        = map(string)
  default     = {}
}

variable "docker_image" {
  description = "Public Docker image to run on the EC2 instance."
  type        = string
  default     = "nginx:latest"
}
