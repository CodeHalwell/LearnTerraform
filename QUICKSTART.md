# Quick Start Guide

Get started with Terraform and Azure in 5 minutes!

## Prerequisites

- Install Terraform (see main README for installation instructions)
- Azure account with active subscription
- Azure CLI installed and configured

## Azure Setup

### 1. Install Azure CLI

**macOS:**
```bash
brew install azure-cli
```

**Linux:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Windows:**
Download from https://aka.ms/installazurecliwindows

### 2. Login to Azure

```bash
az login
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

## Your First Terraform Project

### 1. Create a Simple Azure Project

Create a new directory and a file named `main.tf`:

```hcl
terraform {
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

resource "azurerm_resource_group" "example" {
  name     = "rg-terraform-quickstart"
  location = "East US"
  
  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads the Azure provider needed for your configuration.

### 3. Plan Your Changes

```bash
terraform plan
```

This shows what Azure resources Terraform will create before it does it.

### 4. Apply Your Configuration

```bash
terraform apply
```

Type `yes` when prompted. Terraform will create the resource group!

### 5. Verify

```bash
az group show --name rg-terraform-quickstart
# You should see your resource group details
```

### 6. Clean Up

```bash
terraform destroy
```

Type `yes` to remove the Azure resource group.

## The Terraform Workflow

1. **Write** - Define Azure infrastructure as code
2. **Initialize** - `terraform init` - Download Azure provider
3. **Plan** - `terraform plan` - Preview Azure resource changes
4. **Apply** - `terraform apply` - Create/update Azure infrastructure
5. **Destroy** - `terraform destroy` - Clean up Azure resources (when done)

## Next Steps

### Learn by Example

Work through the examples in order:

1. **examples/01-hello-world** - Your first Terraform project (local provider)
2. **examples/02-azure-vm** - Create Azure Virtual Machine
3. **examples/03-variables** - Use variables effectively
4. **examples/04-modules** - Build reusable Azure VNet module

### Essential Commands

```bash
# Format your code
terraform fmt

# Validate syntax
terraform validate

# Show current state
terraform show

# List all Azure resources
terraform state list

# Get specific output values
terraform output
```

### Common Patterns

#### Using Variables

Create `variables.tf`:
```hcl
variable "location" {
  default = "East US"
}
```

Use in `main.tf`:
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = var.location
}
```

Override with:
```bash
terraform apply -var="location=West Europe"
```

#### Using Outputs

In `outputs.tf`:
```hcl
output "resource_group_id" {
  value = azurerm_resource_group.example.id
}
```

View outputs:
```bash
terraform output
terraform output resource_group_id
```

## Helpful Tips

1. **Always run `terraform plan` before `terraform apply`**
   - Preview Azure resource changes before making them
   - Catch configuration errors early

2. **Use version control for your `.tf` files**
   - Track infrastructure changes
   - Collaborate with team members

3. **Never commit sensitive data**
   - Add `*.tfvars` to `.gitignore`
   - Use Azure Key Vault or environment variables for secrets

4. **Format your code regularly**
   - Run `terraform fmt` before committing
   - Keeps code consistent

5. **Use modules for reusable Azure components**
   - Don't repeat yourself
   - Share common VNet, VM, and other patterns

## Getting Help

- **Terraform Documentation**: https://www.terraform.io/docs
- **Azure Provider Docs**: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- **Azure Terraform Tutorials**: https://learn.hashicorp.com/collections/terraform/azure-get-started
- **Registry**: https://registry.terraform.io
- **Community**: https://discuss.hashicorp.com/c/terraform-core
- **Examples**: Explore the examples/ directory in this repo

## Common Errors and Solutions

### "Provider not found"
```bash
# Solution: Initialize the project
terraform init
```

### "Azure authentication failed"
```bash
# Solution: Login to Azure CLI
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### "Resource already exists"
```bash
# Solution: Import existing Azure resource
terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup
```

### "State lock error"
```bash
# Solution: Wait for other operations to complete
# Or force unlock (use carefully):
terraform force-unlock LOCK_ID
```

### Syntax errors
```bash
# Solution: Validate your configuration
terraform validate
terraform fmt
```

---

Happy Terraforming! 🚀
