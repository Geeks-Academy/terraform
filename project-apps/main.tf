terraform {
  backend "s3" {
    profile = "irland"
    bucket  = "codebazar-states"
    region  = "eu-west-1"
    key     = "states/apps/terraform.tfstate"
  }
}

data "terraform_remote_state" "project-iam" {
  backend = "s3"
  config = {
    bucket  = "codebazar-states"
    region  = "eu-west-1"
    profile = "irland"
    key     = "states/iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "project-core" {
  backend = "s3"
  config = {
    bucket  = "codebazar-states"
    region  = "eu-west-1"
    profile = "irland"
    key     = "states/core/terraform.tfstate"
  }
}

module "sg" {
  source = "./security"

  vpc_id = data.terraform_remote_state.project-core.outputs.vpc_common_id
}

module "ProgrammersOnly" {
  source = "./ProgrammersOnly"

  prefix               = "programmers-only"
  key_name             = data.terraform_remote_state.project-core.outputs.key_name
  iam_instance_profile = data.terraform_remote_state.project-iam.outputs.instance_profile_ec2
  security_groups      = [module.sg.ecs_sg_id]
  subnets              = data.terraform_remote_state.project-core.outputs.subnets

}