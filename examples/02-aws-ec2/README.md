# Example 2: AWS EC2 Instance

This example demonstrates how to create an EC2 instance on AWS with a web server.

## Prerequisites

- AWS Account
- AWS CLI configured with credentials
- Terraform installed

## What This Creates

- A security group allowing HTTP (port 80) and SSH (port 22) traffic
- An EC2 instance running Amazon Linux 2
- A simple Apache web server serving a "Hello from Terraform" page

## How to Run

1. **Configure AWS Credentials:**
   ```bash
   aws configure
   ```
   Or set environment variables:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Preview the changes:**
   ```bash
   terraform plan
   ```

4. **Apply the configuration:**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

5. **Access the web server:**
   After apply completes, you'll see output with the instance's public IP and DNS.
   Open the web_url in your browser to see the page.

6. **Clean up (Important - to avoid AWS charges):**
   ```bash
   terraform destroy
   ```
   Type `yes` when prompted.

## Customization

You can customize the deployment by creating a `terraform.tfvars` file:

```hcl
aws_region    = "us-west-2"
instance_type = "t2.small"
instance_name = "my-web-server"
environment   = "production"
```

Or pass variables on the command line:
```bash
terraform apply -var="instance_type=t2.small"
```

## What You'll Learn

- How to use AWS provider
- How to create EC2 instances
- How to work with security groups
- How to use data sources to fetch AMI information
- How to use variables and outputs
- How to use user_data for instance initialization

## Cost

This example uses a t2.micro instance, which is eligible for AWS Free Tier. However, if you exceed free tier limits, you will incur charges. Always remember to destroy resources when done.

## Next Steps

Move on to example 03-variables to learn more about variable handling.
