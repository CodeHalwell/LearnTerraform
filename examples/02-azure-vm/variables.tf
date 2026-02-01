variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-vm-example"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-terraform-example"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access (must be provided by the user)"
  type        = string
  # No default value - users must provide their own SSH public key
  # Example: ssh_public_key = file("~/.ssh/id_rsa.pub")
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
