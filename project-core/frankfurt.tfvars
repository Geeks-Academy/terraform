aws_region          = "eu-central-1"
profile_name        = "default"
owner               = "bwieckow"
environment_type    = "dev"
vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
azs                 = ["eu-central-1a", "eu-central-1b"]

# Azure
location                                      = "westeurope"
mgmt_rg_name                                  = "GA-MGMT"
mgmt_rg_lock_name                             = "GA-MGMT-RG-Lock"
budget_ag_name                                = "GA-Budget-AG"
budget_credit_card_owner_name                 = "PWachulec"
budget_credit_card_owner_email                = "p.wachulec@gmail.com"
budget_slack_webhook_notification_name        = "Slack notification"
budget_slack_webhook_notification_service_uri = "https://hooks.slack.com/services/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"