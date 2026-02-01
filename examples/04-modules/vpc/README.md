# VPC Module

A reusable Terraform module for creating AWS VPC infrastructure.

## Features

- Creates a VPC with configurable CIDR block
- Creates public and private subnets across multiple availability zones
- Optionally creates an Internet Gateway
- Configurable DNS settings
- Automatic subnet CIDR calculation
- Customizable tags

## Usage

```hcl
module "vpc" {
  source = "./vpc"

  vpc_name             = "my-vpc"
  vpc_cidr             = "10.0.0.0/16"
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
| vpc_name | Name of the VPC | string | - | yes |
| vpc_cidr | CIDR block for the VPC | string | "10.0.0.0/16" | no |
| public_subnet_count | Number of public subnets | number | 2 | no |
| private_subnet_count | Number of private subnets | number | 2 | no |
| enable_dns_hostnames | Enable DNS hostnames | bool | true | no |
| enable_dns_support | Enable DNS support | bool | true | no |
| create_internet_gateway | Create Internet Gateway | bool | true | no |
| tags | Tags for all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr | CIDR block of the VPC |
| public_subnet_ids | IDs of public subnets |
| private_subnet_ids | IDs of private subnets |
| public_subnet_cidrs | CIDR blocks of public subnets |
| private_subnet_cidrs | CIDR blocks of private subnets |
| internet_gateway_id | ID of the Internet Gateway |
| public_route_table_id | ID of the public route table |

## Example

See the parent directory's `main.tf` for a complete example using this module.
