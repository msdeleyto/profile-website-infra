variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "ecr_repository_arns" {
  description = "List of ECR repository ARNs that ECS can pull from"
  type        = list(string)
  sensitive   = true
}
