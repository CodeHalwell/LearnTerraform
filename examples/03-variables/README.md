# Example 3: Variables and Validation

This example demonstrates advanced variable usage in Terraform.

## What This Demonstrates

- Different variable types (string, number, bool, list, map, object)
- Variable validation
- Sensitive variables
- Local values
- Template files
- Complex variable types
- Default values and optional attributes

## How to Run

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Try with defaults:**
   ```bash
   terraform apply
   ```

3. **Try with custom values:**
   ```bash
   terraform apply -var="server_count=3" -var="environment=staging"
   ```

4. **Use a variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars as needed
   terraform apply
   ```

5. **Check outputs:**
   ```bash
   terraform output
   cat deployment-summary.txt
   cat server-1.json
   ```

6. **Clean up:**
   ```bash
   terraform destroy
   ```

## Variable Types Demonstrated

### String Variables
```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

### Number Variables
```hcl
variable "server_count" {
  type    = number
  default = 1
}
```

### Boolean Variables
```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

### List Variables
```hcl
variable "enabled_features" {
  type    = list(string)
  default = ["monitoring", "backup"]
}
```

### Map Variables
```hcl
variable "default_tags" {
  type = map(string)
  default = {
    Project = "Example"
  }
}
```

### Object Variables
```hcl
variable "network_config" {
  type = object({
    vpc_cidr     = string
    subnet_count = number
    enable_nat   = bool
  })
}
```

## Variable Validation

This example shows how to validate variable values:

```hcl
variable "environment" {
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}
```

Try invalid values to see validation in action:
```bash
terraform apply -var="environment=invalid"
```

## Sensitive Variables

Variables marked as sensitive won't show their values in output:

```hcl
variable "api_key" {
  sensitive = true
}
```

## What You'll Learn

- How to use different variable types
- How to validate variable inputs
- How to work with local values
- How to use template files
- How to handle sensitive data
- How to use complex variable types
- How to provide default values

## Best Practices Demonstrated

1. **Validation** - Always validate inputs to catch errors early
2. **Sensitive Data** - Mark sensitive variables appropriately
3. **Default Values** - Provide sensible defaults
4. **Documentation** - Describe all variables clearly
5. **Type Safety** - Use specific types instead of `any`

## Next Steps

Move on to example 04-modules to learn about creating reusable modules.
