# Azure VNet Module
# This module creates a Virtual Network with configurable settings

# Create a resource group for the VNet
resource "azurerm_resource_group" "main" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Reference existing resource group if not creating one
data "azurerm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.main[0].name : data.azurerm_resource_group.existing[0].name
  location            = var.create_resource_group ? azurerm_resource_group.main[0].location : data.azurerm_resource_group.existing[0].location
}

# Create the Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = local.location
  resource_group_name = local.resource_group_name
  dns_servers         = var.dns_servers

  tags = merge(
    var.tags,
    {
      Name = var.vnet_name
    }
  )
}

# Create public subnets
resource "azurerm_subnet" "public" {
  count                = var.public_subnet_count
  name                 = "${var.vnet_name}-public-${count.index + 1}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, count.index)]
}

# Create private subnets
resource "azurerm_subnet" "private" {
  count                = var.private_subnet_count
  name                 = "${var.vnet_name}-private-${count.index + 1}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, count.index + var.public_subnet_count)]
}

# Create Network Security Group for public subnets
resource "azurerm_network_security_group" "public" {
  count               = var.public_subnet_count > 0 ? 1 : 0
  name                = "${var.vnet_name}-public-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vnet_name}-public-nsg"
    }
  )
}

# Associate NSG with public subnets
resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.public_subnet_count
  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.public[0].id
}

# Create Network Security Group for private subnets
resource "azurerm_network_security_group" "private" {
  count               = var.private_subnet_count > 0 ? 1 : 0
  name                = "${var.vnet_name}-private-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  tags = merge(
    var.tags,
    {
      Name = "${var.vnet_name}-private-nsg"
    }
  )
}

# Associate NSG with private subnets
resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.private_subnet_count
  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.private[0].id
}
