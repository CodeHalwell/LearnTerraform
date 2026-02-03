# String variable with validation
variable "environment" {
  description = "Environment name (dev, staging, or production)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

# Number variable with validation
variable "server_count" {
  description = "Number of servers to create"
  type        = number
  default     = 1
  
  validation {
    condition     = var.server_count > 0 && var.server_count <= 10
    error_message = "Server count must be between 1 and 10."
  }
}

# String variable
variable "server_name" {
  description = "Base name for servers"
  type        = string
  default     = "app-server"
}

# String variable with validation pattern
variable "server_size" {
  description = "Server size (small, medium, or large)"
  type        = string
  default     = "small"
  
  validation {
    condition     = can(regex("^(small|medium|large)$", var.server_size))
    error_message = "Server size must be small, medium, or large."
  }
}

# List variable
variable "enabled_features" {
  description = "List of features to enable"
  type        = list(string)
  default     = ["monitoring", "backup"]
}

# Map variable
variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "Example"
    ManagedBy = "Terraform"
  }
}

# Object variable
variable "network_config" {
  description = "Network configuration"
  type = object({
    vpc_cidr     = string
    subnet_count = number
    enable_nat   = bool
  })
  default = {
    vpc_cidr     = "10.0.0.0/16"
    subnet_count = 2
    enable_nat   = true
  }
}

# Sensitive variable (for passwords, keys, etc.)
variable "api_key" {
  description = "API key for external service"
  type        = string
  default     = "demo-key-not-real"
  sensitive   = true
}

# Boolean variable
variable "enable_monitoring" {
  description = "Enable monitoring for servers"
  type        = bool
  default     = true
}

# Optional variable (Terraform 1.3+)
variable "optional_config" {
  description = "Optional configuration settings"
  type = object({
    setting1 = optional(string, "default1")
    setting2 = optional(number, 100)
  })
  default = {}
}
