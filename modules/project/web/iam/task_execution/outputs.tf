output "role_arn" {
  description = "ARN of the ECS role used by ECS task execution"
  value       = module.role.arn
  sensitive   = true
}

output "role_name" {
  description = "Name of the ECS role used by ECS task execution"
  value       = module.role.name
}
