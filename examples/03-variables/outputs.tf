output "server_configurations" {
  description = "List of server configuration files created"
  value       = local_file.server_config[*].filename
}

output "deployment_summary" {
  description = "Deployment summary file"
  value       = local_file.summary.filename
}

output "server_names" {
  description = "List of server names"
  value       = local.server_names
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "all_tags" {
  description = "All tags applied to resources"
  value       = local.common_tags
}

# Sensitive output
output "api_key_length" {
  description = "Length of the API key (not the key itself)"
  value       = length(var.api_key)
}
