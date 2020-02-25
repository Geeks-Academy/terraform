variable "type" {
  type        = string
  description = "Instance type"
}

variable "ssh_key" {
  type        = string
  description = "Instance SSH key name"
}

variable "subnet" {
  type        = string
  description = "Subnet ID"
}

variable "ec2_sg_id" {
  type        = string
  description = "EC2 security group ID"
}

variable "prefix" {
  type        = string
  description = "Instance name prefix"
}
