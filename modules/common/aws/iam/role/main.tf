terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = var.principals.type
      identifiers = var.principals.identifiers
    }
  }
}

resource "aws_iam_role" "this" {
  name        = var.name
  description = var.description

  assume_role_policy = data.aws_iam_policy_document.this.json

  tags = {
    Name = var.name
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}
