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

  name        = "${var.project_name}-ec2-ecs"
  description = "IAM policy for EC2 instances managed by ECS"
  statements = [
    {
      sid    = "ECSAgent"
      effect = "Allow"
      actions = [
        "ecs:RegisterContainerInstance",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:StartTelemetrySession",
        "ecs:UpdateContainerInstancesState",
        "ecs:Submit*"
      ]
      resources = ["*"]
    },
    {
      sid       = "ECRAuth"
      effect    = "Allow"
      actions   = ["ecr:GetAuthorizationToken"]
      resources = ["*"]
    },
    {
      sid    = "ECRPull"
      effect = "Allow"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      resources = var.ecr_repository_arns
    },
    {
      sid    = "CloudWatchLogs"
      effect = "Allow"
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ]
      resources = [
        "arn:aws:logs:*:*:log-group:/ecs/${var.project_name}/*",
        "arn:aws:logs:*:*:log-group:/ecs/${var.project_name}/*:*"
      ]
    },
    {
      sid    = "CloudWatchMetrics"
      effect = "Allow"
      actions = [
        "cloudwatch:PutMetricData"
      ]
      resources = ["*"]
    }
  ]
}

module "role" {
  source = "../../../../common/aws/iam/role"

  name        = "${var.project_name}-ec2-ecs"
  description = "EC2 instance role for ECS container instances"
  principals = {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
  policy_arns = [module.policy.arn]
}

module "instance_profile" {
  source = "../../../../common/aws/iam/instance_profile"

  name      = "${var.project_name}-ec2-ecs"
  role_name = module.role.name
}
