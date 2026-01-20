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
  dynamic "statement" {
    for_each = var.statements

    content {
      sid       = statement.value["sid"]
      effect    = statement.value["effect"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
      condition {
        test     = statement.value["test"]
        variable = statement.value["variable"]
        values   = statement.value["values"]
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  policy      = data.aws_iam_policy_document.this.json

  tags = {
    Name = var.name
  }
}
