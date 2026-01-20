variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC id to attach the network gateway to"
  type        = string
}

variable "rules" {
  description = "NACL rules"
  type = list(object({
    rule_number = number
    egress      = bool
    protocol    = string
    cidr        = string
    from_port   = number
    to_port     = number
  }))
}
