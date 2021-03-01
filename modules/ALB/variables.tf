# MANDATORY
variable "name" {
  type        = string
  description = "ALB name"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group ids"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet ids"
}

variable "ssl_target_groups" {
  type        = list(map(string))
  description = "A list of maps of target groups and hostnames that should be accessable with HTTPS"
}

variable "target_groups" {
  type        = list(map(string))
  description = "A list of maps of target groups and hostnames that should be accessable with HTTP"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of SSL certificate"
}

# OPTIONAL
variable "tags" {
  type = map

  default = {
    owner = "bwieckow"
  }
}

variable "internal" {
  type        = bool
  description = "(optional) describe your variable"
  default     = false
}

variable "idle_timeout" {
  type        = string
  description = "Idle timeout"
  default     = "3600"
}

variable "http2_enabled" {
  type        = bool
  description = "If HTTP2 enabled"
  default     = true
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Deletion protaction"
  default     = false
}

variable "certificate_arns" {
  type        = list(string)
  description = "ARNs of additional SSL certificates"
  default     = []
}