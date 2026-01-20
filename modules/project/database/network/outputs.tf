output "subnet_ids" {
  description = "Subnet ids"
  value       = { for k, v in module.subnets : k => v.subnet_id }
}
