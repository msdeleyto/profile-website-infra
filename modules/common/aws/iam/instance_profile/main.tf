terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-instance-profile"
  role = var.role_name

  tags = {
    Name = "${var.name}-instance-profile"
  }
}
