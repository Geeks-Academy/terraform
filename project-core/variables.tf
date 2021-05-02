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

variable "account_number" {
  type        = string
  description = "AWS account number"
}


# Azure

variable "location" {
  type        = string
  description = "Location of the Azure resources"
}

variable "mgmt_rg_name" {
  type        = string
  description = "RG for common resources"
}

variable "mgmt_rg_lock_name" {
  type        = string
  description = "Lock prevents before accidentaly removing the resource group."
}

variable "budget_ag_name" {
  type        = string
  description = "Name of the Action Group which will be notified when the budget will be burnt"
}

variable "budget_credit_card_owner_name" {
  type        = string
  description = "The name of the person whose card is attached to the budget"
}

variable "budget_credit_card_owner_email" {
  type        = string
  description = "The email address of the person whose card is attached to the budget"
}

variable "budget_slack_webhook_notification_name" {
  type        = string
  description = "value"
}

variable "budget_slack_webhook_notification_service_uri" {
  type        = string
  description = "value"
}