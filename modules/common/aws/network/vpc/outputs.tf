output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "igw_id" {
  description = "IGW ID"
  value       = aws_internet_gateway.this.id
}
