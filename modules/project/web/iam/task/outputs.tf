output "role_arn" {
  description = "ARN of the ECS role used by ECS tasks"
  value       = module.role.arn
  sensitive   = true
}

output "role_name" {
  description = "Name of the ECS role used by ECS tasks"
  value       = module.role.name
}
