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

variable "domain_name" {
  description = "Domain used for certificate creation"
  type        = string
}

variable "alb_target_type" {
  description = "Target type for ALB target groups"
  type        = string
}

variable "alb_target_groups" {
  description = "Map of service routing configurations for ALB"
  type = map(object({
    container_port         = number
    health_check_path      = string
    health_check_matcher   = string
    health_check_interval  = number
    health_check_timeout   = number
    healthy_threshold      = number
    unhealthy_threshold    = number
    deregistration_delay   = number
    listener_rule_priority = number
    path_pattern           = string
    host_header            = optional(string)
  }))
}
