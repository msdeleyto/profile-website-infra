output "subnet_ids" {
  description = "Subnet ids"
  value       = { for k, v in module.network : k => v.subnet_id }
}
