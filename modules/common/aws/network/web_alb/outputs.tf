output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.this.arn
  sensitive   = true
}
