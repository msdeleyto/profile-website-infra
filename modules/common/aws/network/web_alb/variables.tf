variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "security_group_ids" {
  description = "Security group id for ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet ids for ALB"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least 2 public subnets required for ALB (multi-AZ)."
  }
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS listener (optional - if not provided, only HTTP listener is created)"
  type        = string
  sensitive   = true
}

variable "host" {
  description = "Host used in the listener to redirect to https"
  type        = string
}

variable "target_type" {
  description = "Target type for ALB target groups"
  type        = string
}
