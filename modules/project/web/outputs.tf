output "subnet_ids" {
  description = "Subnet ids"
  value       = module.network.subnet_ids
}

output "alb_security_group_id" {
  description = "ALB security group id"
  value       = module.network.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "ECS security group id"
  value       = module.network.ecs_security_group_id
}
