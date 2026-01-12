# IAM Module Outputs

output "task_execution_role_arn" {
  description = "ARN of the ECS task execution role (used by ECS to pull images and write logs)"
  value       = aws_iam_role.task_execution.arn
  sensitive   = true
}

output "task_execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.task_execution.name
}

output "task_role_arn" {
  description = "ARN of the ECS task role (used by application container for AWS API calls)"
  value       = aws_iam_role.task.arn
  sensitive   = true
}

output "task_role_name" {
  description = "Name of the ECS task role"
  value       = aws_iam_role.task.name
}

output "ecs_instance_role_arn" {
  description = "ARN of the EC2 instance role used by ECS container instances"
  value       = aws_iam_role.instance.arn
  sensitive   = true
}

output "ecs_instance_role_name" {
  description = "Name of the EC2 instance role used by ECS container instances"
  value       = aws_iam_role.instance.name
}

output "ecs_instance_profile_name" {
  description = "Instance profile name for ECS EC2 instances"
  value       = aws_iam_instance_profile.this.name
}

output "ecs_instance_profile_arn" {
  description = "Instance profile ARN for ECS EC2 instances"
  value       = aws_iam_instance_profile.this.arn
  sensitive   = true
}
