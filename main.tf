terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "random_id" "resource_suffix" {
  byte_length = 4
}

resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = "${var.project_name}-key-${random_id.resource_suffix.hex}"
  public_key = tls_private_key.ec2.public_key_openssh

  tags = merge(var.tags, {
    Name = "${var.project_name}-key-${random_id.resource_suffix.hex}"
  })
}

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-sg-${random_id.resource_suffix.hex}"
  description = "Security group for the ${var.project_name} EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Application"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-sg-${random_id.resource_suffix.hex}"
  })
}

resource "aws_instance" "app" {
  ami                         = coalesce(var.ami_id, data.aws_ssm_parameter.amazon_linux_2023_ami.value)
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  key_name                    = aws_key_pair.ec2.key_name
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    dnf install -y docker
    systemctl enable --now docker
    docker pull ${var.docker_image}
    docker rm -f app 2>/dev/null || true
    docker run -d --restart unless-stopped --name app -p ${var.app_port}:8501 ${var.docker_image}
  EOF

  tags = merge(var.tags, {
    Name = var.project_name
  })
}
