terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source = "../../common/aws/network/vpc"

  name   = var.project_name
  cidr   = var.vpc_cidr
}

module "igw" {
  source = "../../common/aws/network/igw"

  name   = var.project_name
  vpc_id = module.vpc.id
}
