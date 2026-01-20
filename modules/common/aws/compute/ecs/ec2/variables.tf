variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "ami_id" {
  description = "AMI id for the EC2 launch template"
  type        = string
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

variable "asg_max" {
  description = "Maximum number of EC2 instances in ASG"
  type        = number
}

variable "asg_min" {
  description = "Minimum number of EC2 instances in ASG"
  type        = number
}

variable "desired_count" {
  description = "Desired number of instances"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS cluster id"
  type        = string
}

variable "task_definition_arn" {
  description = "ECS task definition ARN"
  type        = string
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "container_name" {
  description = "Container name for the load balancer"
  type        = string
}

variable "container_port" {
  description = "Container port for the load balancer"
  type        = number
}
