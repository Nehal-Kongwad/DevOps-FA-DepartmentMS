terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = "eu-north-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Create a new security group for the Campus Connect server
resource "aws_security_group" "campus_connect_sg" {
  name        = "campus-connect-terraform-sg"
  description = "Security group for Campus Connect DevOps server"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application frontend
  ingress {
    description = "Frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application backend
  ingress {
    description = "Backend"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "campus-connect-terraform-sg"
  }
}

# Create a new EC2 instance
resource "aws_instance" "campus_connect_server" {
  ami           = "ami-05bfa4a7765f38076"
  instance_type = "t3.small"
  key_name      = "fa1-key"

  vpc_security_group_ids = [aws_security_group.campus_connect_sg.id]

  tags = {
    Name = "campus-connect-terraform-server"
  }
}