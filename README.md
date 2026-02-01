# Learn Terraform with Azure

A comprehensive guide to learning and using Terraform with Microsoft Azure - the Infrastructure as Code (IaC) tool for Azure cloud.

## Table of Contents

- [What is Terraform?](#what-is-terraform)
- [Why Use Terraform with Azure?](#why-use-terraform-with-azure)
- [Installation](#installation)
- [Azure Setup](#azure-setup)
- [Getting Started](#getting-started)
- [Core Concepts](#core-concepts)
- [Basic Commands](#basic-commands)
- [Configuration Structure](#configuration-structure)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## What is Terraform?

Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define and provision infrastructure using a declarative configuration language called HashiCorp Configuration Language (HCL).

With Terraform and Azure, you can:
- Manage Azure infrastructure as code
- Version control your Azure infrastructure
- Automate Azure resource provisioning
- Create reusable Azure infrastructure components
- Track changes and maintain state of Azure resources

## Why Use Terraform with Azure?

- **Infrastructure as Code**: Define Azure resources in version-controlled configuration files
- **Declarative**: Describe what Azure resources you want, not how to create them
- **Version Control**: Track Azure infrastructure changes in Git
- **Reusable**: Create modules for repeatable Azure infrastructure patterns
- **Planning**: Preview Azure resource changes before applying them
- **State Management**: Keep track of your Azure infrastructure state
- **Azure Integration**: Native support for Azure services through the AzureRM provider
- **Multi-Environment**: Easily manage dev, staging, and production environments

## Installation

### macOS
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Linux (Ubuntu/Debian)
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Windows (Chocolatey)
```bash
choco install terraform
```

### Verify Installation
```bash
terraform version
```

## Azure Setup

Before you can use Terraform with Azure, you need to set up authentication.

### Option 1: Azure CLI Authentication (Recommended for Development)

1. **Install Azure CLI:**
   - macOS: `brew install azure-cli`
   - Linux: Follow [official docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - Windows: Download from Microsoft

2. **Login to Azure:**
   ```bash
   az login
   ```

3. **Set your subscription (if you have multiple):**
   ```bash
   az account list --output table
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```

### Option 2: Service Principal (Recommended for Production/CI/CD)

1. **Create a Service Principal:**
   ```bash
   az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
   ```

2. **Set environment variables:**
   ```bash
   export ARM_CLIENT_ID="<appId>"
   export ARM_CLIENT_SECRET="<password>"
   export ARM_SUBSCRIPTION_ID="<subscription_id>"
   export ARM_TENANT_ID="<tenant>"
   ```

### Verify Azure Access
```bash
az account show
```

## Getting Started

### 1. Create Your First Azure Configuration

Create a file named `main.tf`:

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
  name     = "rg-terraform-demo"
  location = "East US"
}
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads the required providers.

### 3. Plan Changes

```bash
terraform plan
```

Preview what Azure resources Terraform will create.

### 4. Apply Changes

```bash
terraform apply
```

Type `yes` to confirm and create the Azure resources.

### 5. Verify in Azure

```bash
az group show --name rg-terraform-demo
```

### 6. Destroy Resources

```bash
terraform destroy
```

Remove all Azure resources created by Terraform.

## Core Concepts

### Providers

Providers are plugins that interact with APIs of cloud providers and services.

```hcl
provider "azurerm" {
  features {}
  
  subscription_id = "00000000-0000-0000-0000-000000000000"
}
```

### Resources

Resources are the most important element in Terraform. They represent infrastructure objects.

```hcl
resource "azurerm_virtual_machine" "web" {
  name                  = "web-vm"
  location              = "East US"
  resource_group_name   = azurerm_resource_group.main.name
  vm_size               = "Standard_B2s"
}
```

### Variables

Variables allow you to parameterize your configurations.

```hcl
variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}
```

### Outputs

Outputs display information about your infrastructure.

```hcl
output "vm_ip" {
  value = azurerm_public_ip.main.ip_address
}
```

### Data Sources

Data sources allow you to fetch information from existing resources.

```hcl
data "azurerm_image" "ubuntu" {
  name                = "ubuntu-20-04"
  resource_group_name = "images-rg"
}
```

### Modules

Modules are containers for multiple resources that are used together.

```hcl
module "network" {
  source = "./modules/network"
  
  address_space = "10.0.0.0/16"
  name          = "my-vnet"
}
```

### State

Terraform stores the state of your infrastructure in a state file (`terraform.tfstate`). This file maps your configuration to real-world resources.

## Basic Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize a Terraform working directory |
| `terraform plan` | Preview changes before applying |
| `terraform apply` | Create or update infrastructure |
| `terraform destroy` | Destroy all managed infrastructure |
| `terraform fmt` | Format configuration files |
| `terraform validate` | Check configuration syntax |
| `terraform show` | Show current state or plan |
| `terraform output` | Display output values |
| `terraform state list` | List resources in state |
| `terraform state show <resource>` | Show details of a resource |
| `terraform refresh` | Update state to match remote resources |
| `terraform import` | Import existing infrastructure |
| `terraform workspace list` | List workspaces |
| `terraform workspace new <name>` | Create a new workspace |
| `terraform workspace select <name>` | Switch to a workspace |

## Configuration Structure

A typical Terraform project structure:

```
.
├── main.tf           # Main configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Output definitions
├── providers.tf      # Provider configurations
├── terraform.tfvars  # Variable values (not committed to git)
├── versions.tf       # Required Terraform and provider versions
├── modules/          # Reusable modules
│   └── vnet/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/     # Environment-specific configs
    ├── dev/
    ├── staging/
    └── prod/
```

## Examples

### Example 1: Azure Virtual Machine

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

variable "location" {
  default = "East US"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnet-example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "nic-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    Name = "ExampleVM"
  }
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.example.id
}

output "private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}
```

### Example 2: Azure Storage Account

> **Note:** This example uses the `random` provider. Include it in your `required_providers` block:
> ```hcl
> terraform {
>   required_providers {
>     azurerm = {
>       source  = "hashicorp/azurerm"
>       version = "~> 3.0"
>     }
>     random = {
>       source  = "hashicorp/random"
>       version = "~> 3.0"
>     }
>   }
> }
> ```

```hcl
resource "azurerm_resource_group" "storage" {
  name     = "rg-storage"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "stexample${random_id.storage_id.hex}"
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Name        = "StorageAccount"
    Environment = "Dev"
  }
}

resource "random_id" "storage_id" {
  byte_length = 4
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
```

### Example 3: Using Variables and Locals

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs"
  type        = number
  default     = 1
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  count               = var.vm_count
  name                = "vm-app-${count.index + 1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"

  tags = merge(
    local.common_tags,
    {
      Name = "app-${count.index + 1}"
    }
  )
}
```

## Best Practices

### 1. Use Version Control
- Always commit your `.tf` files to version control
- Never commit `terraform.tfstate` or `.tfvars` files with secrets
- Use `.gitignore` for sensitive files

### 2. Remote State
Store state remotely for team collaboration using Azure Storage:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

### 3. Use Variables
- Parameterize everything that might change
- Provide sensible defaults
- Document variables with descriptions

### 4. Organize Code
- Split configurations into multiple files
- Use modules for reusable components
- Follow a consistent naming convention

### 5. Use Terraform Formatting
```bash
terraform fmt -recursive
```

### 6. Validate Before Apply
```bash
terraform validate
terraform plan
```

### 7. Use Workspaces for Environments
```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### 8. Tag Resources
Always tag resources for better organization and cost tracking:

```hcl
tags = {
  Environment = "production"
  Project     = "myapp"
  ManagedBy   = "terraform"
}
```

### 9. Use Data Sources
Leverage data sources instead of hardcoding values:

```hcl
data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "existing" {
  name                = "existing-vnet"
  resource_group_name = "existing-rg"
}
```

### 10. Implement Locking
Use state locking to prevent concurrent modifications:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

Note: Azure Storage backend automatically supports state locking.

## Common Patterns

### Count vs For_Each

**Using count:**
```hcl
resource "azurerm_linux_virtual_machine" "server" {
  count               = 3
  name                = "vm-server-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  
  tags = {
    Name = "server-${count.index}"
  }
}
```

**Using for_each (preferred for flexibility):**
```hcl
variable "servers" {
  type = map(object({
    vm_size = string
  }))
  default = {
    web = { vm_size = "Standard_B2s" }
    app = { vm_size = "Standard_B4ms" }
  }
}

resource "azurerm_linux_virtual_machine" "server" {
  for_each = var.servers
  
  name                = "vm-${each.key}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = each.value.vm_size
  
  tags = {
    Name = each.key
  }
}
```

### Dynamic Blocks

```hcl
resource "azurerm_network_security_group" "example" {
  name                = "nsg-example"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

### Conditional Resources

```hcl
resource "azurerm_linux_virtual_machine" "example" {
  count = var.create_vm ? 1 : 0
  
  name                = "vm-example"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
}
```

### Depends On

```hcl
resource "azurerm_linux_virtual_machine" "web" {
  name                = "vm-web"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  
  depends_on = [azurerm_network_security_group.web]
}
```

## Troubleshooting

### Common Issues

**Issue: Provider plugin not found**
```bash
terraform init
```

**Issue: State lock errors**
```bash
# Force unlock (use carefully)
terraform force-unlock <LOCK_ID>
```

**Issue: State drift**
```bash
terraform refresh
terraform plan
```

**Issue: Resource already exists**
```bash
# Import existing Azure resource
terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup
```

**Issue: Configuration syntax errors**
```bash
terraform validate
terraform fmt
```

### Debug Mode

Enable detailed logging:
```bash
export TF_LOG=DEBUG
terraform apply
```

Log levels: TRACE, DEBUG, INFO, WARN, ERROR

Save logs to a file:
```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
terraform apply
```

## Resources

### Official Documentation
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Registry](https://registry.terraform.io/) - Providers and modules
- [HashiCorp Learn - Azure](https://learn.hashicorp.com/collections/terraform/azure-get-started) - Interactive tutorials

### Azure-Specific Resources
- [Azure Terraform QuickStart Templates](https://github.com/Azure/terraform)
- [Azure CAF Terraform Landing Zones](https://github.com/Azure/caf-terraform-landingzones)
- [Azure Verified Modules](https://aka.ms/avm)
- [Microsoft Learn - Terraform on Azure](https://docs.microsoft.com/en-us/azure/developer/terraform/)

### Community Resources
- [Terraform GitHub](https://github.com/hashicorp/terraform)
- [Terraform Community Forum](https://discuss.hashicorp.com/c/terraform-core)
- [Azure Terraform Provider Issues](https://github.com/hashicorp/terraform-provider-azurerm/issues)
- [r/Terraform](https://www.reddit.com/r/Terraform/)

### Books and Courses
- "Terraform: Up and Running" by Yevgeniy Brikman
- "Terraform in Action" by Scott Winkler
- HashiCorp Certified: Terraform Associate Certification
- Microsoft Learn: Infrastructure as Code with Terraform

### Tools
- [tflint](https://github.com/terraform-linters/tflint) - Terraform linter with Azure rules
- [terraform-docs](https://github.com/terraform-docs/terraform-docs) - Generate documentation
- [terragrunt](https://terragrunt.gruntwork.io/) - Terraform wrapper
- [checkov](https://www.checkov.io/) - Static code analysis for IaC (Azure support)
- [infracost](https://www.infracost.io/) - Azure cloud cost estimates
- [terraform-compliance](https://terraform-compliance.com/) - BDD testing for Terraform

### Best Practice Guides
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Azure Terraform Best Practices](https://docs.microsoft.com/en-us/azure/developer/terraform/best-practices)
- [Azure Landing Zones with Terraform](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/terraform-landing-zone)

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This repository is for educational purposes.

---

**Happy Infrastructure as Code! 🚀**