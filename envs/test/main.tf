module "vpc" {
  source = "../../modules/project/network/core"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "web_subnets" {
  source = "../../modules/project/network/web"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  nacl_rules = [
    {
      rule_number = 100
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
  sg_rules = {
    cidr_rules = {
      ingress = [
        {
          cidr        = "0.0.0.0/0"
          from_port   = 443
          ip_protocol = "tcp"
          to_port     = 443
        }
      ]
      egress = []
    }
    sg_id_rules = {
      ingress = []
      egress  = []
    }
  }
}

module "database_subnets" {
  source = "../../modules/project/network/database"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  sg_rules = {
    cidr_rules = {
      ingress = []
      egress  = []
    }
    sg_id_rules = {
      ingress = [
        {
          referenced_security_group_id = module.web_subnets.security_group_id
          from_port                    = 5432
          ip_protocol                  = "tcp"
          to_port                      = 5432
        }
      ]
      egress = []
    }
  }
}
