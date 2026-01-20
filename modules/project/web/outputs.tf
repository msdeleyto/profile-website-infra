output "subnet_ids" {
  description = "Subnet ids"
  value       = { for k, v in module.network : k => v.subnet_id }
}

output "alb_security_group_id" {
  description = "ALB security group id"
  value       = module.network.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "ECS security group id"
  value       = module.network.ecs_security_group_id
}
