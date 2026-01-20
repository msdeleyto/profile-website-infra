variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "task_execution_role_arn" {
  description = "Task execution role ARN"
  type        = string
  sensitive   = true
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
  sensitive   = true
}

variable "service_image" {
  description = "ECS service image"
  type        = string
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs configuration"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "EC2 instance type for ECS container instances"
  type        = string
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile to attach to ECS EC2 instances"
  type        = string
}

variable "security_group_id" {
  description = "Security group id for ECS tasks"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}
