output "role_arn" {
  description = "ARN of the EC2 instance role used by ECS container instances"
  value       = module.role.arn
  sensitive   = true
}

output "role_name" {
  description = "Name of the EC2 instance role used by ECS container instances"
  value       = module.role.name
}

output "instance_profile_arn" {
  description = "Instance profile ARN for ECS EC2 instances"
  value       = module.instance_profile.arn
  sensitive   = true
}

output "instance_profile_name" {
  description = "Instance profile name for ECS EC2 instances"
  value       = module.instance_profile.name
}
