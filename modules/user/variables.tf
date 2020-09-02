variable "username" {
  description = "Username to be created"
  type        = string
}

variable "group_membership" {
  description = "Group name to which to assign user"
  type        = string
}

variable "policy_attachement_arn" {
  description = "Policy ARN to be attached"
  type        = string
  default     = ""
}

variable "console_access" {
  description = "If user have console access"
  type        = bool
  default     = false
}

variable "programmatic_access" {
  description = "If user have console access"
  type        = bool
  default     = false
}