variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "description" {
  description = "Description used for the resource"
  type        = string
}

variable "principals" {
  description = "Principals to assume the role"
  type = object({
    type        = string
    identifiers = list(string)
  })
}

variable "policy_arns" {
  description = "ARN of the policies to attach to this role"
  type        = list(string)
  sensitive   = true
}
