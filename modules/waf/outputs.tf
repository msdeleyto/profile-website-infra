# WAF Module Outputs

output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.arn
  sensitive   = true
}

output "web_acl_name" {
  description = "Name of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.name
}

output "web_acl_capacity" {
  description = "Web ACL capacity units used"
  value       = aws_wafv2_web_acl.this.capacity
}
