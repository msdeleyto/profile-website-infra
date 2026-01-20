terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "nacl" {
  source = "../../../common/aws/network/nacl"

  name   = "${var.project_name}-web"
  vpc_id = var.vpc_id
  rules  = var.nacl_rules
}

module "subnets" {
  count  = length(var.availability_zones)
  source = "../../../common/aws/network/public_subnet"

  name                = "${var.project_name}-web"
  name_suffix         = "-${count.index + 1}"
  vpc_id              = var.vpc_id
  cidr_block          = cidrsubnet(var.vpc_cidr, 6, count.index)
  availability_zone   = var.availability_zones[count.index]
  internet_gateway_id = var.igw_id
  nacl_id             = module.nacl.id
}

module "security_group" {
  source = "../../../common/aws/network/security_group"

  name   = "${var.project_name}-web"
  vpc_id = var.vpc_id
  rules  = var.sg_rules
}

module "acm" {
  source = "../../../common/aws/network/acm"

  project_name = var.project_name
  domain_name  = var.domain_name
}

module "alb" {
  source = "../../../common/aws/network/web_alb"

  name               = var.project_name
  vpc_id             = var.vpc_id
  subnet_ids         = module.subnets[*].subnet_id
  certificate_arn    = module.acm.certificate_arn
  target_type        = var.alb_target_type
  security_group_ids = [module.security_group.id]
  target_groups      = var.alb_target_groups
}
