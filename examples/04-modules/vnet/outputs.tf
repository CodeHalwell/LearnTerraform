output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.main.address_space
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region of the VNet"
  value       = local.location
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = azurerm_subnet.private[*].id
}

output "public_subnet_address_prefixes" {
  description = "Address prefixes of public subnets"
  value       = azurerm_subnet.public[*].address_prefixes
}

output "private_subnet_address_prefixes" {
  description = "Address prefixes of private subnets"
  value       = azurerm_subnet.private[*].address_prefixes
}

output "public_nsg_id" {
  description = "ID of the public Network Security Group"
  value       = try(azurerm_network_security_group.public[0].id, "")
}

output "private_nsg_id" {
  description = "ID of the private Network Security Group"
  value       = try(azurerm_network_security_group.private[0].id, "")
}
