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

  name   = "${var.project_name}-database"
  vpc_id = var.vpc_id
  rules  = []
}

module "subnets" {
  count  = length(var.availability_zones)
  source = "../../../common/aws/network/private_subnet"

  name              = "${var.project_name}-database"
  name_suffix       = "-${count.index + 1}"
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 6, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  nacl_id           = module.nacl.id
}

module "security_group" {
  source = "../../../common/aws/network/security_group"

  name   = "${var.project_name}-database"
  vpc_id = var.vpc_id
  rules  = var.sg_rules
}
