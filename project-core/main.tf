terraform {
  backend "s3" {
    bucket  = "programmers-only-states"
    region  = "eu-central-1"
    key     = "states/core/terraform.tfstate"
  }
}

data "terraform_remote_state" "project-iam" {
  backend = "s3"
  config = {
    bucket  = "programmers-only-states"
    region  = "eu-central-1"
    key     = "states/iam/terraform.tfstate"
  }
}

module "vpc_common" {
  source = "./vpc"

  owner               = var.owner
  environment_type    = var.environment_type
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnet_cidr = var.private_subnet_cidr
  azs                 = var.azs
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}

output "subnets" {
  value = module.vpc_common.public_subnets
}

output "vpc_common_id" {
  value = module.vpc_common.vpc_id
}