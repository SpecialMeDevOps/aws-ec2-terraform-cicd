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
  description = "Optional AMI ID. If omitted, the latest Amazon Linux 2023 AMI is used."
  type        = string
  default     = null
  nullable    = true
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Deprecated. Terraform creates and uses its own EC2 key pair."
  type        = string
  default     = null
  nullable    = true
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
