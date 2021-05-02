terraform {
  backend "s3" {
    bucket         = "trstates"
    region         = "eu-central-1"
    key            = "states/core/terraform.tfstate"
    dynamodb_table = "trlock"
  }
}

data "terraform_remote_state" "project-iam" {
  backend = "s3"
  config = {
    bucket = "trstates"
    region = "eu-central-1"
    key    = "states/iam/terraform.tfstate"
  }
}

module "vpc_common" {
  source = "./vpc"

  owner            = var.owner
  environment_type = var.environment_type
  vpc_cidr         = var.vpc_cidr
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  azs              = var.azs
}

module "bastion" {
  source = "./bastion"

  prefix               = "geeks-academy"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = data.terraform_remote_state.project-iam.outputs.instance_profile_ec2
  public_subnets       = module.vpc_common.public_subnets
  private_subnets      = module.vpc_common.private_subnets
  vpc_id               = module.vpc_common.vpc_id
}

resource "azurerm_resource_group" "mgmt_rg" {
  name     = var.mgmt_rg_name
  location = var.location
}

resource "azurerm_management_lock" "mgmt_rg_lock" {
  name       = var.mgmt_rg_lock_name
  scope      = azurerm_resource_group.mgmt_rg.id
  lock_level = "CanNotDelete"
  notes      = "This lock prevents before accidentaly removing the resource group with important resources, i.e. action group used for alarms in budget definition."
}

resource "azurerm_monitor_action_group" "name" {
  name                = var.budget_ag_name
  short_name          = var.budget_ag_name
  resource_group_name = var.mgmt_rg_name

  email_receiver {
    name          = var.budget_credit_card_owner_name
    email_address = var.budget_credit_card_owner_email
  }

  webhook_receiver {
    name = var.budget_slack_webhook_notification_name
    service_uri = var.budget_slack_webhook_notification_service_uri
    use_common_alert_schema = false
  }
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}

output "public_subnets" {
  value = module.vpc_common.public_subnets
}

output "private_subnets" {
  value = module.vpc_common.private_subnets
}

output "vpc_common_id" {
  value = module.vpc_common.vpc_id
}
