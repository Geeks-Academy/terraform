variable "username" {
  description = "Username to be created"
  type        = string
}

variable "group_membership" {
  description = "Group name to which to assign user"
  type        = string
}

variable "force_mfa_policy_arn" {
  description = "Force MFA set up"
  type        = string
}