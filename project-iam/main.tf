terraform {
  backend "s3" {
    bucket = "programmers-only-states"
    region = "eu-central-1"
    key    = "states/iam/terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 2.39"
  region  = var.aws_region
  profile = var.profile_name
}

module "users" {
  source = "./users"

  force_mfa_policy = module.roles.force_mfa_policy_arn
}

module "roles" {
  source = "./roles"
}

output "instance_profile_ec2" {
  value = module.roles.ec2_instance_profile_name
}
