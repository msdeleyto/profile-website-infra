variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "region" {
  description = "Region for VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR block for VPC"
  type        = string
}
