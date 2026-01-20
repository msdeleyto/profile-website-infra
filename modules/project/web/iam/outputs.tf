output "task_execution_role_name" {
  description = "Name of the ECS role used by ECS task execution"
  value       = module.task_execution.role_name
}

output "task_role_name" {
  description = "Name of the ECS role used by ECS tasks"
  value       = module.task.role_name
}

output "ec2_role_name" {
  description = "Name of the EC2 instance role used by ECS container instances"
  value       = module.ec2.role_name
}

output "ec2_instance_profile_name" {
  description = "Instance profile name for ECS EC2 instances"
  value       = module.ec2.instance_profile_name
}
