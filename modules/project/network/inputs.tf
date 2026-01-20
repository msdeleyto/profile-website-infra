variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "web_nacl_rules" {
  description = "Rules to apply to web subnets NACL"
  type = list(object({
    rule_number = number
    egress      = bool
    protocol    = string
    cidr        = string
    from_port   = number
    to_port     = number
  }))
}
