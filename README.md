# Learn Terraform

A comprehensive guide to learning and using Terraform - the Infrastructure as Code (IaC) tool.

## Table of Contents

- [What is Terraform?](#what-is-terraform)
- [Why Use Terraform?](#why-use-terraform)
- [Installation](#installation)
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

With Terraform, you can:
- Manage infrastructure across multiple cloud providers (AWS, Azure, GCP, etc.)
- Version control your infrastructure
- Automate infrastructure provisioning
- Create reusable infrastructure components
- Track changes and maintain state

## Why Use Terraform?

- **Cloud Agnostic**: Works with multiple cloud providers and services
- **Declarative**: Describe what you want, not how to create it
- **Version Control**: Track infrastructure changes in Git
- **Reusable**: Create modules for repeatable infrastructure patterns
- **Planning**: Preview changes before applying them
- **State Management**: Keep track of your infrastructure state
- **Community**: Large ecosystem of providers and modules

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

## Getting Started

### 1. Create Your First Configuration

Create a file named `main.tf`:

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "hello" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
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

Preview what Terraform will create.

### 4. Apply Changes

```bash
terraform apply
```

Type `yes` to confirm and create the resources.

### 5. Destroy Resources

```bash
terraform destroy
```

Remove all resources created by Terraform.

## Core Concepts

### Providers

Providers are plugins that interact with APIs of cloud providers and services.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

### Resources

Resources are the most important element in Terraform. They represent infrastructure objects.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

### Variables

Variables allow you to parameterize your configurations.

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

### Outputs

Outputs display information about your infrastructure.

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

### Data Sources

Data sources allow you to fetch information from existing resources.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

### Modules

Modules are containers for multiple resources that are used together.

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
  name       = "my-vpc"
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
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/     # Environment-specific configs
    ├── dev/
    ├── staging/
    └── prod/
```

## Examples

### Example 1: AWS EC2 Instance

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
```

### Example 2: AWS S3 Bucket

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-${random_id.bucket_id.hex}"

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.example.id
}
```

### Example 3: Using Variables and Locals

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

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
Store state remotely for team collaboration:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
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
data "aws_availability_zones" "available" {
  state = "available"
}
```

### 10. Implement Locking
Use state locking to prevent concurrent modifications:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

## Common Patterns

### Count vs For_Each

**Using count:**
```hcl
resource "aws_instance" "server" {
  count = 3
  ami   = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "server-${count.index}"
  }
}
```

**Using for_each (preferred for flexibility):**
```hcl
variable "servers" {
  type = map(object({
    instance_type = string
  }))
  default = {
    web = { instance_type = "t2.micro" }
    app = { instance_type = "t2.small" }
  }
}

resource "aws_instance" "server" {
  for_each = var.servers
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value.instance_type
  
  tags = {
    Name = each.key
  }
}
```

### Dynamic Blocks

```hcl
resource "aws_security_group" "example" {
  name = "example"
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

### Conditional Resources

```hcl
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

### Depends On

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  depends_on = [aws_security_group.web]
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
# Import existing resource
terraform import aws_instance.example i-1234567890abcdef0
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
- [Terraform Registry](https://registry.terraform.io/) - Providers and modules
- [HashiCorp Learn](https://learn.hashicorp.com/terraform) - Interactive tutorials

### Provider Documentation
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Google Cloud Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

### Community Resources
- [Terraform GitHub](https://github.com/hashicorp/terraform)
- [Terraform Community Forum](https://discuss.hashicorp.com/c/terraform-core)
- [r/Terraform](https://www.reddit.com/r/Terraform/)

### Books and Courses
- "Terraform: Up and Running" by Yevgeniy Brikman
- "Terraform in Action" by Scott Winkler
- HashiCorp Certified: Terraform Associate Certification

### Tools
- [tflint](https://github.com/terraform-linters/tflint) - Terraform linter
- [terraform-docs](https://github.com/terraform-docs/terraform-docs) - Generate documentation
- [terragrunt](https://terragrunt.gruntwork.io/) - Terraform wrapper
- [checkov](https://www.checkov.io/) - Static code analysis for IaC
- [infracost](https://www.infracost.io/) - Cloud cost estimates

### Best Practice Guides
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Terraform Best Practices](https://aws.amazon.com/blogs/apn/terraform-best-practices-for-aws-users/)
- [Azure Terraform Best Practices](https://docs.microsoft.com/en-us/azure/developer/terraform/best-practices)

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This repository is for educational purposes.

---

**Happy Infrastructure as Code! 🚀**