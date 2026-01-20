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

  project_name          = var.project_name
  vpc_id                = var.vpc_id
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  web_security_group_id = var.web_security_group_id
}
