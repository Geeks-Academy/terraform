aws_region          = "eu-central-1"
profile_name        = "default"
owner               = "bwieckow"
environment_type    = "dev"
vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
azs                 = ["eu-central-1a", "eu-central-1b"]

# Azure
mgmt_rg_name    = "GA-MGMT"
location        = "westeurope"