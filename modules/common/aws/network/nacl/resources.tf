terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-nacl"
  }
}

resource "aws_network_acl_rule" "this" {
  count = length(var.rules)

  network_acl_id = aws_network_acl.this.id
  rule_number    = var.rules[count.index].rule_number
  egress         = var.rules[count.index].egress
  protocol       = var.rules[count.index].protocol
  rule_action    = "allow"
  cidr_block     = var.rules[count.index].cidr
  from_port      = var.rules[count.index].from_port
  to_port        = var.rules[count.index].to_port
}
