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

variable "domain_name" {
  description = "Domain used for certificate creation"
  type        = string
}

variable "alb_target_type" {
  description = "Target type for ALB target groups"
  type        = string
}
