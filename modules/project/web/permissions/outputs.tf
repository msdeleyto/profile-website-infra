output "task_execution_role_arn" {
  description = "ARN of the ECS role used by ECS task execution"
  value       = module.role.arn
  sensitive   = true
}

output "task_execution_role_name" {
  description = "Name of the ECS role used by ECS task execution"
  value       = module.role.name
}

output "task_role_arn" {
  description = "ARN of the ECS role used by ECS tasks"
  value       = module.role.arn
  sensitive   = true
}

output "task_role_name" {
  description = "Name of the ECS role used by ECS tasks"
  value       = module.role.name
}

output "ec2_role_name" {
  description = "Name of the EC2 instance role used by ECS container instances"
  value       = module.role.name
}

output "ec2_instance_profile_name" {
  description = "Instance profile name for ECS EC2 instances"
  value       = module.instance_profile.name
}
