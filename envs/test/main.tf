data "aws_caller_identity" "current" {}

locals {
  ecr_repository_arns = [
    "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/web/profile"
  ]
}

module "core" {
  source = "../../modules/project/core"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "web" {
  source = "../../modules/project/web"

  project_name       = var.project_name
  vpc_id             = module.core.vpc_id
  igw_id             = module.core.igw_id
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  nacl_rules = [
    {
      rule_number = 100
      egress      = false
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
    },
    {
      rule_number = 200
      egress      = false
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
      from_port   = 443
      to_port     = 443
    },
    {
      rule_number = 100
      egress      = true
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
      from_port   = 1024
      to_port     = 65535
    }
  ]
  alb_target_type = "instance"
  domain_name     = "test.msdeleyto.es"
  alb_target_groups = {
    web = {
      container_port         = 80
      health_check_path      = "/"
      health_check_matcher   = "200-299"
      health_check_interval  = 30
      health_check_timeout   = 5
      healthy_threshold      = 2
      unhealthy_threshold    = 3
      deregistration_delay   = 30
      listener_rule_priority = 100
      path_pattern           = "/*"
      host_header            = "test.msdeleyto.es"
    }
  }
  ecr_repository_arns = local.ecr_repository_arns
}

module "database" {
  source = "../../modules/project/database"

  project_name          = var.project_name
  vpc_id                = module.core.vpc_id
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  web_security_group_id = module.web.ecs_security_group_id
}
