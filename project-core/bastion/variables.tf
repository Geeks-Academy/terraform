variable "key_name" {
  description = "This is SSH key name for provisioned instances in this ECS cluster."
}

variable "iam_instance_profile" {
  description = "This is instance profile name for provisioned instances in this ECS cluster."
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnets" {
  description = "This is public subnets list."
  type        = list
}

variable "private_subnets" {
  description = "This is private subnets list."
  type        = list
}

variable "tags" {
  type = map

  default = {
    owner        = "bwieckow"
    "Managed by" = "Terraform"
  }
}

variable "prefix" {
  type        = string
  description = "Instance name prefix"
}

variable "account_number" {
  type        = string
  description = "AWS account number"
}