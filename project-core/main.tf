terraform {
  backend "s3" {
    bucket         = "statestf"
    region         = "eu-central-1"
    key            = "states/core/terraform.tfstate"
    dynamodb_table = "trlock"
  }
}

data "terraform_remote_state" "project-iam" {
  backend = "s3"
  config = {
    bucket = "statestf"
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
