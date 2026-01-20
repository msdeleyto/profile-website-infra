terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "task_execution" {
  source = "./task_execution"

  project_name        = var.project_name
  ecr_repository_arns = var.ecr_repository_arns
}

module "task" {
  source = "./task"

  project_name = var.project_name
}

module "ec2" {
  source = "./ec2"

  project_name        = var.project_name
  ecr_repository_arns = var.ecr_repository_arns
}
