module "network" {
  source = "../../modules/project/network"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  web_nacl_rules     = [
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
}
