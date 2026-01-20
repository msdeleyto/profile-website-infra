output "arn" {
  description = "ARN of the role"
  value       = aws_iam_role.this.arn
  sensitive   = true
}

output "name" {
  description = "Name of the role"
  value       = aws_iam_role.this.name
}
