# Azure VNet Module

A reusable Terraform module for creating Azure Virtual Network infrastructure.

## Features

- Creates a Virtual Network with configurable address space
- Creates public and private subnets with automatic CIDR calculation
- Optionally creates or uses existing resource group
- Creates Network Security Groups for public and private subnets
- Configurable DNS servers
- Customizable tags

## Usage

```hcl
module "vnet" {
  source = "./vnet"

  vnet_name           = "my-vnet"
  location            = "East US"
  resource_group_name = "rg-network"
  address_space       = ["10.0.0.0/16"]
  public_subnet_count  = 2
  private_subnet_count = 2

  tags = {
    Environment = "production"
    Project     = "example"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vnet_name | Name of the Virtual Network | string | - | yes |
| location | Azure region | string | "East US" | no |
| resource_group_name | Name of the resource group | string | - | yes |
| create_resource_group | Create new or use existing RG | bool | true | no |
| address_space | Address space for the VNet | list(string) | ["10.0.0.0/16"] | no |
| dns_servers | DNS servers for the VNet | list(string) | [] | no |
| public_subnet_count | Number of public subnets | number | 2 | no |
| private_subnet_count | Number of private subnets | number | 2 | no |
| tags | Tags for all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | ID of the Virtual Network |
| vnet_name | Name of the Virtual Network |
| vnet_address_space | Address space of the VNet |
| resource_group_name | Name of the resource group |
| location | Azure region of the VNet |
| public_subnet_ids | IDs of public subnets |
| private_subnet_ids | IDs of private subnets |
| public_subnet_address_prefixes | Address prefixes of public subnets |
| private_subnet_address_prefixes | Address prefixes of private subnets |
| public_nsg_id | ID of public NSG |
| private_nsg_id | ID of private NSG |

## Example

See the parent directory's `main.tf` for a complete example using this module.
