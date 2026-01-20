data "aws_caller_identity" "current" {}

locals {
  ecr_repository_arns = {
    web = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/web/profile"
  }
  service_images = {
    web = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/web/profile:arm64"
  }
}

module "core" {
  source = "../../modules/project/core"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "web" {
  source = "../../modules/project/web"

  project_name        = var.project_name
  vpc_id              = module.core.vpc_id
  igw_id              = module.core.igw_id
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  nacl_rules          = var.web_nacl_rules
  domain_name         = var.domain_name
  ecr_repository_arns = [local.ecr_repository_arns["web"]]
  service_image       = local.service_images["web"]
  aws_region          = var.aws_region
  instance_type       = var.instance_type
  use_spot            = true
}

module "database" {
  source = "../../modules/project/database"

  project_name          = var.project_name
  vpc_id                = module.core.vpc_id
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  web_security_group_id = module.web.ecs_security_group_id
}
