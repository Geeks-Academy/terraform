variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "profile_name" {
  type        = string
  description = "AWS profile name"
}

variable "owner" {
  type        = string
  description = "Owner name"
}

variable "environment_type" {
  type        = string
  description = "Environment type"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "public_subnets" {
  type        = list
  description = "Public subnet CIDRs"
}

variable "private_subnets" {
  type        = list
  description = "Private subnet CIDRs"
}

variable "azs" {
  type        = list
  description = "Availability zones"
}

