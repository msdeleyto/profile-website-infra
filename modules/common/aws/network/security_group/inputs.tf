variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "name_suffix" {
  description = "Suffix used for resource naming"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC id to attach the network gateway to"
  type        = string
}

variable "rules" {
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
