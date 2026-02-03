# Example 4: Using Terraform Modules
# This example demonstrates how to use a local module

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Use the VNet module
module "vnet" {
  source = "./vnet"

  vnet_name            = var.vnet_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  address_space        = [var.address_space]
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count

  tags = {
    Environment = var.environment
    Project     = "terraform-example"
    ManagedBy   = "Terraform"
  }
}

# Use module outputs in other resources
resource "azurerm_network_security_group" "example" {
  name                = "nsg-example"
  location            = module.vnet.location
  resource_group_name = module.vnet.resource_group_name

  security_rule {
    name                       = "HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name        = "example-nsg"
    Environment = var.environment
  }
}
