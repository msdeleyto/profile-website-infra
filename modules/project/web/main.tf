terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source = "./network"

  project_name       = var.project_name
  vpc_id             = var.vpc_id
  igw_id             = var.igw_id
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  nacl_rules         = var.nacl_rules
  alb_target_type    = var.alb_target_type
  domain_name        = var.domain_name
  alb_target_groups  = var.alb_target_groups
}

module "iam" {
  source = "./iam"

  project_name        = var.project_name
  ecr_repository_arns = var.ecr_repository_arns
}
