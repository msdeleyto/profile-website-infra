variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "igw_id" {
  description = "IGW id"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "nacl_rules" {
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

variable "sg_rules" {
  description = "Security group rules"
  type = object({
    cidr_rules = object({
      ingress = list(object({
        cidr        = string
        from_port   = number
        ip_protocol = string
        to_port     = number
      }))
      egress = list(object({
        cidr        = string
        from_port   = number
        ip_protocol = string
        to_port     = number
      }))
    })
    sg_id_rules = object({
      ingress = list(object({
        referenced_security_group_id = string
        from_port                    = number
        ip_protocol                  = string
        to_port                      = number
      }))
      egress = list(object({
        referenced_security_group_id = string
        from_port                    = number
        ip_protocol                  = string
        to_port                      = number
      }))
    })
  })
}
