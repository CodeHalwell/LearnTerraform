# Quick Start Guide

Get started with Terraform in 5 minutes!

## Prerequisites

- Install Terraform (see main README for installation instructions)
- For cloud examples: AWS, Azure, or GCP account with credentials configured

## Your First Terraform Project

### 1. Create a Simple Project

Create a new directory and a file named `main.tf`:

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
  filename = "hello.txt"
}
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads the providers needed for your configuration.

### 3. Plan Your Changes

```bash
terraform plan
```

This shows what Terraform will do before it does it.

### 4. Apply Your Configuration

```bash
terraform apply
```

Type `yes` when prompted. Terraform will create the file!

### 5. Verify

```bash
cat hello.txt
# Output: Hello, Terraform!
```

### 6. Clean Up

```bash
terraform destroy
```

Type `yes` to remove the created resources.

## The Terraform Workflow

1. **Write** - Define infrastructure as code
2. **Initialize** - `terraform init` - Download providers
3. **Plan** - `terraform plan` - Preview changes
4. **Apply** - `terraform apply` - Create/update infrastructure
5. **Destroy** - `terraform destroy` - Clean up resources (when done)

## Next Steps

### Learn by Example

Work through the examples in order:

1. **examples/01-hello-world** - Your first Terraform project
2. **examples/02-aws-ec2** - Create cloud resources
3. **examples/03-variables** - Use variables effectively
4. **examples/04-modules** - Build reusable modules

### Essential Commands

```bash
# Format your code
terraform fmt

# Validate syntax
terraform validate

# Show current state
terraform show

# List all resources
terraform state list

# Get specific output values
terraform output
```

### Common Patterns

#### Using Variables

Create `variables.tf`:
```hcl
variable "region" {
  default = "us-east-1"
}
```

Use in `main.tf`:
```hcl
provider "aws" {
  region = var.region
}
```

Override with:
```bash
terraform apply -var="region=us-west-2"
```

#### Using Outputs

In `outputs.tf`:
```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

View outputs:
```bash
terraform output
terraform output instance_ip
```

## Helpful Tips

1. **Always run `terraform plan` before `terraform apply`**
   - Preview changes before making them
   - Catch errors early

2. **Use version control for your `.tf` files**
   - Track infrastructure changes
   - Collaborate with team members

3. **Never commit sensitive data**
   - Add `*.tfvars` to `.gitignore`
   - Use environment variables for secrets

4. **Format your code regularly**
   - Run `terraform fmt` before committing
   - Keeps code consistent

5. **Use modules for reusable components**
   - Don't repeat yourself
   - Share common patterns

## Getting Help

- **Documentation**: https://www.terraform.io/docs
- **Registry**: https://registry.terraform.io
- **Community**: https://discuss.hashicorp.com/c/terraform-core
- **Examples**: Explore the examples/ directory in this repo

## Common Errors and Solutions

### "Provider not found"
```bash
# Solution: Initialize the project
terraform init
```

### "Resource already exists"
```bash
# Solution: Import existing resource
terraform import aws_instance.example i-1234567890
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
