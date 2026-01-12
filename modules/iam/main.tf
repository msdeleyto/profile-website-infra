# IAM Module
# Creates IAM roles for ECS (EC2-backed) infrastructure:
# - Task Execution Role: Used by ECS agent to pull images and write logs
# - Task Role: Used by application containers for AWS API calls
# - Instance Role: Used by EC2 instances running the ECS agent

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

###############################################################################
# Trust Policies (Assume Role)
###############################################################################

data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

###############################################################################
# ECS Task Execution Role
# Used by ECS to pull container images and write logs
###############################################################################

resource "aws_iam_role" "task_execution" {
  name        = "${var.project_name}-ecs-task-execution"
  description = "ECS task execution role - pulls images from ECR and writes logs to CloudWatch"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = {
    Name = "${var.project_name}-ecs-task-execution"
  }
}

# ECR Access - Scoped to specific repositories
data "aws_iam_policy_document" "task_execution_ecr" {
  # GetAuthorizationToken must use "*" resource (account-level operation)
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  # Repository-specific pull permissions
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = var.ecr_repository_arns
  }
}

resource "aws_iam_policy" "task_execution_ecr" {
  name        = "${var.project_name}-ecs-task-execution-ecr"
  description = "Allow ECS task execution to pull images from specific ECR repositories"
  policy      = data.aws_iam_policy_document.task_execution_ecr.json

  tags = {
    Name = "${var.project_name}-ecs-task-execution-ecr"
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_ecr" {
  role       = aws_iam_role.task_execution.name
  policy_arn = aws_iam_policy.task_execution_ecr.arn
}

data "aws_iam_policy_document" "task_execution_logs" {
  statement {
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
}

resource "aws_iam_policy" "task_execution_logs" {
  name        = "${var.project_name}-ecs-task-execution-logs"
  description = "Allow ECS task execution to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.task_execution_logs.json

  tags = {
    Name = "${var.project_name}-ecs-task-execution-logs"
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_logs" {
  role       = aws_iam_role.task_execution.name
  policy_arn = aws_iam_policy.task_execution_logs.arn
}

###############################################################################
# ECS Task Role
# Used by application containers for AWS API calls (empty by default)
###############################################################################

resource "aws_iam_role" "task" {
  name        = "${var.project_name}-ecs-task"
  description = "ECS task role - used by application containers for AWS API calls"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = {
    Name = "${var.project_name}-ecs-task"
  }
}

###############################################################################
# ECS EC2 Instance Role
# Used by EC2 instances running the ECS agent
###############################################################################

resource "aws_iam_role" "ecs_instance" {
  name        = "${var.project_name}-ecs-instance"
  description = "EC2 instance role for ECS container instances"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-ecs-instance"
  }
}

# Least-privilege policy for ECS EC2 instances
data "aws_iam_policy_document" "ecs_instance" {
  # ECS agent permissions - register/deregister with cluster
  statement {
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
  }

  # ECR pull permissions (scoped to specific repositories)
  statement {
    sid       = "ECRAuth"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "ECRPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = var.ecr_repository_arns
  }

  # CloudWatch Logs for ECS agent and Container Insights
  statement {
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
  }

  # CloudWatch metrics for Container Insights
  statement {
    sid    = "CloudWatchMetrics"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["ECS/ContainerInsights"]
    }
  }
}

resource "aws_iam_policy" "ecs_instance" {
  name        = "${var.project_name}-ecs-instance"
  description = "Least-privilege policy for ECS EC2 container instances"
  policy      = data.aws_iam_policy_document.ecs_instance.json

  tags = {
    Name = "${var.project_name}-ecs-instance"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = aws_iam_policy.ecs_instance.arn
}

# SSM permissions for ECS Exec and Session Manager (optional but recommended)
resource "aws_iam_role_policy_attachment" "ecs_instance_ssm" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.project_name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name

  tags = {
    Name = "${var.project_name}-ecs-instance-profile"
  }
}
