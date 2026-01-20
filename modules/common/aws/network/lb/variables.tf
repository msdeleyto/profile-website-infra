variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  sensitive   = true
}

variable "security_group_ids" {
  description = "Security group id for ALB"
  type        = list(string)
  sensitive   = true
}

variable "subnet_ids" {
  description = "List of subnet ids for ALB"
  type        = list(string)
  sensitive   = true

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least 2 public subnets required for ALB (multi-AZ)."
  }
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS listener (optional - if not provided, only HTTP listener is created)"
  type        = string
  sensitive   = true
}

variable "services" {
  description = "Map of service routing configurations for ALB"
  type = map(object({
    container_port         = number
    health_check_path      = string
    health_check_matcher   = string
    health_check_interval  = number
    health_check_timeout   = number
    healthy_threshold      = number
    unhealthy_threshold    = number
    deregistration_delay   = number
    listener_rule_priority = number
    path_pattern           = string
    host_header            = optional(string)
  }))
}

variable "target_type" {
  description = "Target type for ALB target groups"
  type        = string
}
