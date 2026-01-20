variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming (lowercase, hyphens)"
  type        = string
  default     = "test-profile-website"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must be lowercase with hyphens only (kebab-case)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.64.0/18"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1c", "us-east-1d"]
}

variable "web_nacl_rules" {
  description = "Web layer NACL rules"
  type = list(object({
    rule_number = number
    egress      = bool
    protocol    = string
    cidr        = string
    from_port   = number
    to_port     = number
  }))
  default = [
    {
      rule_number = 100
      egress      = false
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
    },
    {
      rule_number = 200
      egress      = false
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
      from_port   = 443
      to_port     = 443
    },
    {
      rule_number = 100
      egress      = true
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
      from_port   = 1024
      to_port     = 65535
    }
  ]
}

variable "domain_name" {
  description = "Primary domain name for SSL certificate (e.g., example.com)"
  type        = string
  default     = "test.msdeleyto.es"
}

variable "instance_type" {
  description = "EC2 instance type for ECS container instances"
  type        = string
  default     = "t4g.micro"
}
