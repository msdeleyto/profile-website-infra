# ECS Module Variables

variable "project_name" {
  description = "Project name for resource naming (kebab-case only)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.project_name))
    error_message = "Project name must be kebab-case (lowercase letters, numbers, and hyphens only)."
  }
}

# Network Configuration
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

# IAM Configuration
variable "task_execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
  sensitive   = true
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
  sensitive   = true
}

# AWS Region
variable "aws_region" {
  description = "AWS region for CloudWatch logs configuration"
  type        = string
}

variable "service_images" {
  description = "Map of ECS service images"
  type        = map(string)
  sensitive   = true
}

# Services Configuration - Simplified
variable "services" {
  description = "Map of ECS service configurations with sensible defaults"
  type = map(object({
    container_name            = string
    container_port            = number
    task_cpu                  = string
    task_memory               = string
    desired_count             = number
    log_retention_days        = number
    environment_variables     = map(string)
    health_check_command      = optional(list(string))
    health_check_grace_period = number
  }))
}

# ALB Configuration (optional)
variable "alb_target_group_arns" {
  description = "Map of service names to ALB target group ARNs (empty if ALB not enabled)"
  type        = map(string)
}

# EC2 instance parameters for ECS cluster
variable "ecs_instance_type" {
  description = "EC2 instance type for ECS container instances"
  type        = string
}

variable "ecs_asg_min" {
  description = "Minimum number of EC2 instances in ASG"
  type        = number
}

variable "ecs_asg_max" {
  description = "Maximum number of EC2 instances in ASG"
  type        = number
}

variable "ecs_ami_id" {
  description = "Optional custom AMI ID for ECS instances; if empty module uses recommended ECS AMI"
  type        = string
  default     = ""
}

variable "ecs_instance_profile_name" {
  description = "Name of the IAM instance profile to attach to ECS EC2 instances (provided by iam module)"
  type        = string
}
