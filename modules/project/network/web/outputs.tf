output "subnet_ids" {
  description = "Subnet ids"
  value       = { for k, v in module.subnets : k => v.subnet_id }
}

output "security_group_id" {
  description = "Security group id"
  value       = module.security_group.id
}
