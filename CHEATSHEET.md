# Terraform Cheat Sheet

Quick reference for common Terraform commands and patterns.

## Essential Commands

### Initialization and Setup
```bash
terraform init              # Initialize working directory
terraform init -upgrade     # Upgrade providers to latest version
terraform get              # Download/update modules
```

### Planning and Applying
```bash
terraform plan                      # Show execution plan
terraform plan -out=plan.tfplan    # Save plan to file
terraform apply                     # Apply changes
terraform apply plan.tfplan        # Apply saved plan
terraform apply -auto-approve      # Apply without confirmation
terraform apply -target=resource   # Apply specific resource
```

### Destruction
```bash
terraform destroy                   # Destroy all resources
terraform destroy -auto-approve    # Destroy without confirmation
terraform destroy -target=resource # Destroy specific resource
```

### State Management
```bash
terraform state list                    # List resources in state
terraform state show <resource>         # Show resource details
terraform state mv <source> <dest>      # Move/rename resource
terraform state rm <resource>           # Remove resource from state
terraform state pull                    # Download state
terraform state push                    # Upload state
terraform refresh                       # Update state from real resources
```

### Import and Output
```bash
terraform import <resource> <id>   # Import existing resource
terraform output                   # Show all outputs
terraform output <name>            # Show specific output
terraform output -json             # Output in JSON format
```

### Validation and Formatting
```bash
terraform fmt                # Format files in current directory
terraform fmt -recursive     # Format files recursively
terraform validate          # Validate configuration
terraform version           # Show Terraform version
```

### Workspace Management
```bash
terraform workspace list            # List workspaces
terraform workspace new <name>      # Create workspace
terraform workspace select <name>   # Switch workspace
terraform workspace delete <name>   # Delete workspace
terraform workspace show           # Show current workspace
```

### Debugging
```bash
export TF_LOG=DEBUG        # Enable debug logging
export TF_LOG=TRACE        # Enable trace logging
export TF_LOG_PATH=./terraform.log  # Log to file
terraform console          # Interactive console
```

### Other Useful Commands
```bash
terraform show                    # Show current state
terraform providers              # Show providers
terraform graph                  # Generate dependency graph
terraform graph | dot -Tpng > graph.png  # Visualize graph
terraform force-unlock <lock-id> # Force unlock state
```

## Configuration Syntax

### Providers
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
}
```

### Resources
```hcl
resource "resource_type" "name" {
  argument = "value"
  
  nested_block {
    argument = "value"
  }
}
```

### Variables
```hcl
variable "name" {
  description = "Description"
  type        = string
  default     = "default_value"
  sensitive   = false
  
  validation {
    condition     = length(var.name) > 0
    error_message = "Name cannot be empty."
  }
}
```

### Outputs
```hcl
output "name" {
  description = "Description"
  value       = resource.name.attribute
  sensitive   = false
}
```

### Data Sources
```hcl
data "data_type" "name" {
  argument = "value"
}
```

### Locals
```hcl
locals {
  common_tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

### Modules
```hcl
module "name" {
  source = "./module-path"
  
  input_variable = "value"
}
```

## Variable Types

```hcl
variable "string_var" {
  type = string
}

variable "number_var" {
  type = number
}

variable "bool_var" {
  type = bool
}

variable "list_var" {
  type = list(string)
}

variable "map_var" {
  type = map(string)
}

variable "set_var" {
  type = set(string)
}

variable "object_var" {
  type = object({
    name = string
    age  = number
  })
}

variable "tuple_var" {
  type = tuple([string, number, bool])
}
```

## Built-in Functions

### Numeric Functions
```hcl
abs(-10)              # 10
ceil(5.1)             # 6
floor(5.9)            # 5
max(5, 12, 9)         # 12
min(5, 12, 9)         # 5
```

### String Functions
```hcl
upper("hello")                    # "HELLO"
lower("HELLO")                    # "hello"
title("hello world")              # "Hello World"
trim("  hello  ", " ")           # "hello"
split(",", "a,b,c")              # ["a", "b", "c"]
join(",", ["a", "b", "c"])       # "a,b,c"
replace("hello", "l", "r")       # "herro"
substr("hello", 0, 3)            # "hel"
```

### Collection Functions
```hcl
length([1, 2, 3])                # 3
concat([1, 2], [3, 4])           # [1, 2, 3, 4]
contains([1, 2, 3], 2)           # true
merge({a=1}, {b=2})              # {a=1, b=2}
keys({a=1, b=2})                 # ["a", "b"]
values({a=1, b=2})               # [1, 2]
element([1, 2, 3], 1)            # 2
lookup({a=1, b=2}, "a", 0)       # 1
```

### Encoding Functions
```hcl
jsonencode({a=1})                # '{"a":1}'
jsondecode('{"a":1}')            # {a=1}
base64encode("hello")            # "aGVsbG8="
base64decode("aGVsbG8=")         # "hello"
```

### Filesystem Functions
```hcl
file("path/to/file")             # Read file
fileexists("path/to/file")       # Check if file exists
templatefile("path", vars)       # Render template
```

### Date and Time
```hcl
timestamp()                      # Current timestamp
formatdate("YYYY-MM-DD", timestamp())  # Format timestamp
```

### IP Network Functions
```hcl
cidrsubnet("10.0.0.0/16", 8, 0)  # "10.0.0.0/24"
cidrhost("10.0.0.0/24", 5)       # "10.0.0.5"
```

## Meta-Arguments

### count
```hcl
resource "aws_instance" "server" {
  count = 3
  # Creates 3 instances
  # Access with: aws_instance.server[0]
}
```

### for_each
```hcl
resource "aws_instance" "server" {
  for_each = toset(["web", "app", "db"])
  # Access with: aws_instance.server["web"]
}
```

### depends_on
```hcl
resource "aws_instance" "web" {
  depends_on = [aws_security_group.web]
}
```

### lifecycle
```hcl
resource "aws_instance" "web" {
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags]
  }
}
```

## Expressions

### Conditional
```hcl
condition ? true_val : false_val
var.environment == "prod" ? "t2.large" : "t2.micro"
```

### For Loops
```hcl
# List
[for item in var.list : upper(item)]

# Map
{for k, v in var.map : k => upper(v)}

# With condition
[for item in var.list : item if item != "skip"]
```

### Splat Expressions
```hcl
aws_instance.server[*].id
aws_instance.server[*].public_ip
```

### Dynamic Blocks
```hcl
dynamic "ingress" {
  for_each = var.ingress_rules
  content {
    from_port = ingress.value.from_port
    to_port   = ingress.value.to_port
    protocol  = ingress.value.protocol
  }
}
```

## Backend Configuration

### Azure Storage Backend
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

### Remote Backend
```hcl
terraform {
  backend "remote" {
    organization = "my-org"
    
    workspaces {
      name = "my-workspace"
    }
  }
}
```

## Environment Variables

```bash
# Azure credentials (for service principal authentication)
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"

# Azure alternative (for managed identity)
export ARM_USE_MSI="true"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"

# Terraform variables
export TF_VAR_variable_name="value"
export TF_VAR_location="East US"

# Logging
export TF_LOG="DEBUG"
export TF_LOG_PATH="./terraform.log"
```

## Best Practices

1. Always use version constraints
2. Store state remotely in Azure Storage
3. Use workspaces for environments
4. Enable state locking (automatic with Azure Storage backend)
5. Never commit `.tfvars` files with secrets
6. Use modules for reusable Azure components
7. Tag all Azure resources
8. Use `terraform fmt` before committing
9. Run `terraform validate` regularly
10. Always `terraform plan` before `terraform apply`

---

For more details, see the main [README.md](README.md) and [QUICKSTART.md](QUICKSTART.md).
