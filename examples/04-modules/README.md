# Example 4: Terraform Modules

This example demonstrates how to create and use Terraform modules for reusable infrastructure components.

## What This Demonstrates

- Creating a custom Terraform module
- Using local modules
- Passing variables to modules
- Using module outputs
- Module best practices

## What This Creates

- A VPC module in the `vpc/` directory
- A VPC with public and private subnets using the module
- A security group that uses outputs from the VPC module

## Project Structure

```
04-modules/
├── main.tf           # Root module using the VPC module
├── variables.tf      # Root module variables
├── outputs.tf        # Root module outputs
├── README.md         # This file
└── vpc/              # VPC module
    ├── main.tf       # Module resources
    ├── variables.tf  # Module inputs
    ├── outputs.tf    # Module outputs
    └── README.md     # Module documentation
```

## How to Run

### Prerequisites
- AWS Account
- AWS CLI configured with credentials

### Steps

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Preview the changes:**
   ```bash
   terraform plan
   ```

3. **Apply the configuration:**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

4. **View outputs:**
   ```bash
   terraform output
   ```

5. **Clean up (Important - to avoid AWS charges):**
   ```bash
   terraform destroy
   ```
   Type `yes` when prompted.

## Module Benefits

### Reusability
Modules allow you to define infrastructure once and reuse it many times:

```hcl
module "dev_vpc" {
  source   = "./vpc"
  vpc_name = "dev-vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "prod_vpc" {
  source   = "./vpc"
  vpc_name = "prod-vpc"
  vpc_cidr = "10.1.0.0/16"
}
```

### Abstraction
Modules hide complexity and provide a simple interface:

```hcl
module "vpc" {
  source   = "./vpc"
  vpc_name = "my-vpc"
  # Module handles subnet creation, routing, etc.
}
```

### Organization
Modules help organize large Terraform projects:
- Keep related resources together
- Separate concerns
- Easier to understand and maintain

## Using Remote Modules

Modules can be sourced from various locations:

### Terraform Registry
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
```

### Git Repository
```hcl
module "vpc" {
  source = "git::https://github.com/user/repo.git//modules/vpc?ref=v1.0.0"
}
```

### GitHub
```hcl
module "vpc" {
  source = "github.com/user/repo//modules/vpc?ref=v1.0.0"
}
```

### Local Path
```hcl
module "vpc" {
  source = "./modules/vpc"
}
```

## Module Best Practices

1. **Keep modules focused** - Each module should do one thing well
2. **Document inputs and outputs** - Use descriptions for all variables and outputs
3. **Use variable validation** - Validate inputs where appropriate
4. **Provide sensible defaults** - Make modules easy to use
5. **Version your modules** - Use semantic versioning for stability
6. **Test modules** - Test modules independently before using them
7. **Limit module scope** - Don't make modules too large or complex

## What You'll Learn

- How to create reusable Terraform modules
- How to structure module code
- How to pass data between modules
- How to use module outputs
- Module best practices and patterns

## Next Steps

- Explore the [Terraform Registry](https://registry.terraform.io/) for community modules
- Create more complex modules with nested modules
- Learn about module versioning and publishing
- Explore testing frameworks for Terraform modules

## Additional Resources

- [Terraform Module Documentation](https://www.terraform.io/docs/language/modules/index.html)
- [Module Development Best Practices](https://www.terraform.io/docs/language/modules/develop/index.html)
- [Terraform AWS Modules](https://github.com/terraform-aws-modules)
