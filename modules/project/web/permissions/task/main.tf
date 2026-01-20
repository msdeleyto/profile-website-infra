terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "role" {
  source = "../../../../../common/aws/iam/role"

  name = "${var.project_name}-ecs-task"
  description = "ECS task role - used by application containers for AWS API calls"
  principals = {
    type        = "Service"
    identifiers = ["ecs-tasks.amazonaws.com"]
  }
  policy_arns = []
}
