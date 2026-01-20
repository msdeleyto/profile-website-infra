output "subnet_ids" {
  description = "Subnet ids"
  value       = module.subnets[*].subnet_id
}

output "alb_security_group_id" {
  description = "ALB security group id"
  value       = module.alb_security_group.id
}

output "ecs_security_group_id" {
  description = "ECS security group id"
  value       = module.ecs_security_group.id
}

output "alb_target_group_arn" {
  description = "ALB security group id"
  value       = module.alb.target_group_arn
  sensitive   = true
}
