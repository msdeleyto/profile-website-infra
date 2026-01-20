terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_security_group" "this" {
  name   = "${var.name}-sg${var.name_suffix}"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-sg${var.name_suffix}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cidr_rules" {
  count = length(var.rules.cidr_rules.ingress)

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.rules.cidr_rules.ingress[count.index].cidr
  from_port         = var.rules.cidr_rules.ingress[count.index].from_port
  ip_protocol       = var.rules.cidr_rules.ingress[count.index].ip_protocol
  to_port           = var.rules.cidr_rules.ingress[count.index].to_port
}

resource "aws_vpc_security_group_ingress_rule" "sg_id_rules" {
  count = length(var.rules.sg_id_rules.ingress)

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.rules.sg_id_rules.ingress[count.index].referenced_security_group_id
  from_port                    = var.rules.sg_id_rules.ingress[count.index].from_port
  ip_protocol                  = var.rules.sg_id_rules.ingress[count.index].ip_protocol
  to_port                      = var.rules.sg_id_rules.ingress[count.index].to_port
}

resource "aws_vpc_security_group_egress_rule" "cidr_egress" {
  count = length(var.rules.cidr_rules.egress)

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.rules.cidr_rules.egress[count.index].cidr
  from_port         = var.rules.cidr_rules.egress[count.index].from_port
  ip_protocol       = var.rules.cidr_rules.egress[count.index].ip_protocol
  to_port           = var.rules.cidr_rules.egress[count.index].to_port
}

resource "aws_vpc_security_group_egress_rule" "sg_id_rules" {
  count = length(var.rules.sg_id_rules.egress)

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.rules.sg_id_rules.egress[count.index].referenced_security_group_id
  from_port                    = var.rules.sg_id_rules.egress[count.index].from_port
  ip_protocol                  = var.rules.sg_id_rules.egress[count.index].ip_protocol
  to_port                      = var.rules.sg_id_rules.egress[count.index].to_port
}
