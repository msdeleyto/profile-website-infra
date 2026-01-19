module "network" {
  source = "../../modules/project/network"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}
