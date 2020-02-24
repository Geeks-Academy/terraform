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

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private subnet CIDR"
}
