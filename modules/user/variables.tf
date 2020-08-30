variable "username" {
  description = "Username to be created"
  type        = string
}

variable "group_membership" {
  description = "Group name to which to assign user"
  type        = string
}

variable "allow_password_change_without_mfa" {
  description = "Allow changing the user password without MFA"
  type        = bool
  default     = false
}