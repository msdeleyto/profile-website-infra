output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "igw_id" {
  description = "IGW id"
  value       = module.vpc.igw_id
}
