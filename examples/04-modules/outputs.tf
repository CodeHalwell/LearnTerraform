output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.vnet.vnet_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vnet.private_subnet_ids
}

output "nsg_id" {
  description = "ID of the example network security group"
  value       = azurerm_network_security_group.example.id
}
