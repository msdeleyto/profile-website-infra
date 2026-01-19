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

module "igw" {
  source = "../../common/aws/network/igw"

  name   = var.project_name
  vpc_id = module.vpc.id
}

module "public_subnets" {
  count  = length(var.availability_zones)
  source = "../../common/aws/network/public_subnet"

  name                = var.project_name
  name_suffix         = "-${count.index + 1}"
  vpc_id              = module.vpc.id
  cidr_block          = cidrsubnet(var.vpc_cidr, 6, count.index)
  availability_zone   = var.availability_zones[count.index]
  internet_gateway_id = module.igw.id
}

module "private_subnets" {
  count  = length(var.availability_zones)
  source = "../../common/aws/network/private_subnet"

  name              = var.project_name
  name_suffix       = "-${count.index + 1}"
  vpc_id            = module.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 6, count.index + 10)
  availability_zone = var.availability_zones[count.index]
}
