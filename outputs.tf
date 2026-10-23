output "id" {
  description = "ID of the state machine. Null when create is false."
  value       = var.create ? module.this.state_machine_id : null
}

output "name" {
  description = "Name of the state machine. Null when create is false."
  value       = var.create ? module.this.state_machine_name : null
}

output "arn" {
  description = "ARN of the state machine. Null when create is false."
  value       = var.create ? module.this.state_machine_arn : null
}

output "role_arn" {
  description = "ARN of the execution role. Null when create is false."
  value       = var.create ? module.this.role_arn : null
}

output "log_group_name" {
  description = "Name of the CloudWatch log group receiving execution logs. Null when create is false."
  value       = var.create ? local.log_group_name : null
}

output "tags" {
  description = "Tags applied to every taggable resource, with context.extra_tags merged in. Null when create is false."
  value       = var.create ? local.tags : null
}

output "service_integrations" {
  description = "Service integrations granted to the execution role (X-Ray, and Lambda invoke scoped to lambda_arns). Null when create is false."
  value       = var.create ? local.service_integrations : null
}

output "logging_level" {
  description = "Execution logging level configured on the state machine. Null when create is false."
  value       = var.create ? local.logging_level : null
}
