variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "task_cpu" {
  description = "Task cpu limit"
  type        = string
}

variable "task_memory" {
  description = "Task memory limit"
  type        = string
}

variable "task_execution_role_arn" {
  description = "Task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
}

variable "service_image" {
  description = "ECS service image"
  type        = string
}

variable "container_port" {
  description = "Container exposed port"
  type        = number
}

variable "host_port" {
  description = "Port mapped to container port"
  type        = number
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs configuration"
  type        = string
}

variable "health_check_command" {
  description = "Healthcheck command"
  type        = string
}
