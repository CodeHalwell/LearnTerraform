# Example 3: Advanced Variables and Validation
# This example demonstrates various variable types and validation

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Using different variable types
locals {
  # Local values for computed or composite values
  server_config = {
    name        = var.server_name
    environment = var.environment
    size        = var.server_size
  }
  
  # Combine tags
  common_tags = merge(
    var.default_tags,
    {
      Environment = var.environment
      CreatedBy   = "Terraform"
    }
  )
  
  # Create server list using count
  server_names = [
    for i in range(var.server_count) :
    "${var.server_name}-${i + 1}"
  ]
}

# Create files for each server configuration
resource "local_file" "server_config" {
  count    = var.server_count
  content  = jsonencode({
    name        = local.server_names[count.index]
    environment = var.environment
    size        = var.server_size
    tags        = local.common_tags
    features    = var.enabled_features
  })
  filename = "${path.module}/server-${count.index + 1}.json"
}

# Create a summary file
resource "local_file" "summary" {
  content = templatefile("${path.module}/summary.tpl", {
    environment     = var.environment
    server_count    = var.server_count
    server_names    = local.server_names
    enabled_features = var.enabled_features
    tags            = local.common_tags
  })
  filename = "${path.module}/deployment-summary.txt"
}
