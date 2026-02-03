# Example 1: Hello World with Local File Provider
# This is the simplest Terraform example to get started

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Create a simple text file
resource "local_file" "hello" {
  content  = "Hello, Terraform! Welcome to Infrastructure as Code."
  filename = "${path.module}/hello.txt"
}

# Create another file with dynamic content
resource "local_file" "timestamp" {
  content  = "Created at: ${timestamp()}"
  filename = "${path.module}/timestamp.txt"
}
