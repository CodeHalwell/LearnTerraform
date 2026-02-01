# Example 2: Azure Virtual Machine

This example demonstrates how to create a Linux VM on Azure with a web server.

## Prerequisites

- Azure Account with active subscription
- Azure CLI configured with credentials (`az login`)
- Terraform installed
- SSH key pair generated (`ssh-keygen -t rsa -b 4096`)

## What This Creates

- A resource group to contain all resources
- A virtual network (VNet) with a subnet
- A network security group allowing HTTP (port 80) and SSH (port 22) traffic
- A public IP address
- A network interface
- A Linux virtual machine running Ubuntu 20.04 LTS
- An Nginx web server serving a "Hello from Terraform on Azure!" page

## How to Run

1. **Configure Azure Credentials:**
   ```bash
   az login
   az account list --output table
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```
   
   Or set environment variables:
   ```bash
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   ```

2. **Update SSH Key:**
   Edit `terraform.tfvars` or pass your SSH public key:
   ```bash
   export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)"
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Preview the changes:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

6. **Access the web server:**
   After apply completes, you'll see output with the VM's public IP.
   ```bash
   # SSH into the VM
   ssh azureuser@<public_ip>
   
   # Or view the web page
   curl http://<public_ip>
   ```

7. **Clean up (Important - to avoid Azure charges):**
   ```bash
   terraform destroy
   ```
   Type `yes` when prompted.

## Customization

You can customize the deployment by creating a `terraform.tfvars` file:

```hcl
location            = "West Europe"
vm_size             = "Standard_B4ms"
vm_name             = "my-web-vm"
environment         = "production"
ssh_public_key      = "ssh-rsa AAAAB3... your-key-here"
```

Or pass variables on the command line:
```bash
terraform apply -var="vm_size=Standard_B4ms" -var="location=West Europe"
```

## What You'll Learn

- How to use the Azure provider (azurerm)
- How to create Azure resource groups
- How to create virtual networks and subnets
- How to work with network security groups
- How to create public IPs and network interfaces
- How to create Linux virtual machines
- How to use variables and outputs
- How to use custom_data for VM initialization

## Cost

This example uses a Standard_B2s VM size, which costs approximately $30-40/month if left running. Azure offers free credits for new accounts. Always remember to destroy resources when done to avoid charges.

## Troubleshooting

- **Authentication errors:** Make sure you're logged in with `az login` and have selected the correct subscription
- **SSH key errors:** Ensure your SSH public key is correctly formatted and accessible
- **Quota errors:** Check your Azure subscription quotas for VM cores in the selected region
- **Public IP not assigned:** Public IPs with Dynamic allocation are assigned when the VM starts

## Next Steps

Move on to example 03-variables to learn more about variable handling.
