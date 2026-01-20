terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "policy" {
  source = "../../../../common/aws/iam/policy"

  name        = "${var.project_name}-ecs-task-execution"
  description = "IAM policy for ECS task execution"
  statements = [
    {
      sid    = ""
      effect = "Allow"
      actions = [
        "ecr:GetAuthorizationToken"
      ]
      resources = ["*"]
    },
    {
      sid    = ""
      effect = "Allow"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      resources = var.ecr_repository_arns
    },
    {
      sid    = ""
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = [
        "arn:aws:logs:*:*:log-group:/ecs/${var.project_name}/*",
        "arn:aws:logs:*:*:log-group:/ecs/${var.project_name}/*:*"
      ]
    }
  ]
}

module "role" {
  source = "../../../../common/aws/iam/role"

  name        = "${var.project_name}-ecs-task-execution"
  description = "EC2 instance role for ECS container instances"
  principals = {
    type        = "Service"
    identifiers = ["ecs-tasks.amazonaws.com"]
  }
  policy_arns = [module.policy.arn]
}

