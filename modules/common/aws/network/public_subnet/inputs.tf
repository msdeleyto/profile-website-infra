variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC id to attach the network gateway to"
  type        = string
}

variable "availability_zone" {
  description = "Component name used for resource naming"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for subnet"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}
