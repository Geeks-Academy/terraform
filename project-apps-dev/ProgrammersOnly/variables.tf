variable "key_name" {
  description = "This is SSH key name for provisioned instances in this ECS cluster."
}

variable "iam_instance_profile" {
  description = "This is instance profile name for provisioned instances in this ECS cluster."
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "security_groups" {
  description = "This is security group list for provisioned instances in this ECS cluster."
  type        = list
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
    owner = "bwieckow"
  }
}

variable "prefix" {
  type        = string
  description = "Instance name prefix"
}

variable "asg_role" {
  type        = string
  description = "ASG Role to publish to SNS"
}

variable "sns_topic_arn" {
  type        = string
  description = "SNS ARN for ASG events"
}
