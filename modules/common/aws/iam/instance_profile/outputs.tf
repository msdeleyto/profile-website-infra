output "arn" {
  description = "Instance profile ARN"
  value       = aws_iam_instance_profile.this.arn
  sensitive   = true
}

output "name" {
  description = "Instance profile name"
  value       = aws_iam_instance_profile.this.name
}
