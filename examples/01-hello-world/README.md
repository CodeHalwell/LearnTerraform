# Example 1: Hello World

This is the simplest Terraform example to get you started.

## What This Does

Creates two text files using Terraform:
- `hello.txt` - A simple greeting message
- `timestamp.txt` - A file with the current timestamp

## How to Run

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

4. **Check the created files:**
   ```bash
   cat hello.txt
   cat timestamp.txt
   ```

5. **Clean up:**
   ```bash
   terraform destroy
   ```
   Type `yes` when prompted.

## What You'll Learn

- How to initialize a Terraform project
- How to plan and apply changes
- How to use Terraform resources
- How to destroy resources
- Basic Terraform workflow

## Next Steps

Move on to example 02-azure-vm to learn about Azure cloud resources.
