variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC id to attach the network gateway to"
  type        = string
}
