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
  alb_target_type    = "instance"
  domain_name        = var.domain_name
}

module "iam" {
  source = "./iam"

  project_name        = var.project_name
  ecr_repository_arns = var.ecr_repository_arns
}

module "compute" {
  source = "./compute"

  project_name            = var.project_name
  security_group_id       = module.network.ecs_security_group_id
  instance_type           = var.instance_type
  instance_profile_name   = module.iam.ec2_instance_profile_name
  service_image           = var.service_image
  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn
  aws_region              = var.aws_region
  subnet_ids              = module.network.subnet_ids
  alb_target_group_arn    = module.network.alb_target_group_arn
  use_spot                = var.use_spot
}
