module "vpc" {
  source = "../../common/aws/network/vpc"

  name   = var.project_name
  cidr   = var.vpc_cidr
  region = var.region
}

module "igw" {
  source = "../../common/aws/network/igw"

  name   = var.project_name
  vpc_id = module.vpc.id
}
