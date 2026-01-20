output "task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = module.task_execution.role_arn
  sensitive   = true
}

output "task_role_arn" {
  description = "ECS task role ARN"
  value       = module.task.role_arn
  sensitive   = true
}

output "ec2_role_arn" {
  description = "ECS EC2 container instances role ARN"
  value       = module.ec2.role_arn
  sensitive   = true
}

output "ec2_instance_profile_name" {
  description = "ECS EC2 instance profile name"
  value       = module.ec2.instance_profile_name
}
