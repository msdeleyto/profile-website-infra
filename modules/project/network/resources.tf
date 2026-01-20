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

  name = var.project_name
  cidr = var.vpc_cidr
}

module "web_nacl" {
  source = "../../common/aws/network/nacl"

  name   = "${var.project_name}-web"
  vpc_id = module.vpc.vpc_id
  rules  = var.web_nacl_rules
}

module "web_subnets" {
  count  = length(var.availability_zones)
  source = "../../common/aws/network/public_subnet"

  name                = "${var.project_name}-web"
  name_suffix         = "-${count.index + 1}"
  vpc_id              = module.vpc.vpc_id
  cidr_block          = cidrsubnet(var.vpc_cidr, 6, count.index)
  availability_zone   = var.availability_zones[count.index]
  internet_gateway_id = module.vpc.igw_id
  nacl_id             = module.web_nacl.id
}

module "database_nacl" {
  source = "../../common/aws/network/nacl"

  name   = "${var.project_name}-database"
  vpc_id = module.vpc.vpc_id
  rules  = []
}

module "database_subnets" {
  count  = length(var.availability_zones)
  source = "../../common/aws/network/private_subnet"

  name              = "${var.project_name}-database"
  name_suffix       = "-${count.index + 1}"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 6, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  nacl_id           = module.database_nacl.id
}
