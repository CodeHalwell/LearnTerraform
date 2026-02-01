# Example 4: Using Terraform Modules
# This example demonstrates how to use a local module

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Use the VPC module
module "vpc" {
  source = "./vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count

  tags = {
    Environment = var.environment
    Project     = "terraform-example"
    ManagedBy   = "Terraform"
  }
}

# Use module outputs in other resources
resource "aws_security_group" "example" {
  name_prefix = "example-sg-"
  description = "Example security group in module-created VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "example-security-group"
    Environment = var.environment
  }
}
