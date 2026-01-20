variable "name" {
  description = "Component name used for resource naming"
  type        = string
}

variable "description" {
  description = "Description used for the resource"
  type        = string
}

variable "statements" {
  description = "Policy statements"
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
}
