
terraform {
  backend "s3" {
    profile = "default"
    bucket  = "programmers-only-states"
    region  = "eu-central-1"
    key     = "states/apps/terraform.tfstate"
  }
}

data "terraform_remote_state" "project-iam" {
  backend = "s3"
  config = {
    bucket = "programmers-only-states"
    region = "eu-central-1"
    key    = "states/iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "project-core" {
  backend = "s3"
  config = {
    bucket = "programmers-only-states"
    region = "eu-central-1"
    key    = "states/core/terraform.tfstate"
  }
}

module "sg" {
  source = "./security"

  vpc_id = data.terraform_remote_state.project-core.outputs.vpc_common_id
}

module "route53" {
  source = "./route53"

  vpc_id = data.terraform_remote_state.project-core.outputs.vpc_common_id
}

module "lambda" {
  source = "./lambda"

  iam_for_lambda_arn = data.terraform_remote_state.project-iam.outputs.iam_update_route53_arn
  private_zone_id    = module.route53.private_zone_id
}

module "ProgrammersOnly" {
  source = "./ProgrammersOnly"

  prefix               = "programmers-only"
  key_name             = data.terraform_remote_state.project-core.outputs.key_name
  iam_instance_profile = data.terraform_remote_state.project-iam.outputs.instance_profile_ec2
  security_groups      = [module.sg.ecs_sg_id]
  subnets              = data.terraform_remote_state.project-core.outputs.subnets
  asg_role             = data.terraform_remote_state.project-iam.outputs.allow_posting_to_sns_arn
  sns_topic_arn        = module.lambda.sns_topic_arn
}

### ALB
data "aws_acm_certificate" "programmers_only" {
  domain   = "*.programmers-only.com"
  statuses = ["ISSUED"]
}

module "ALB" {
  source = "../modules/ALB"

  name            = "programmers-only"
  security_groups = [module.sg.ecs_sg_id]
  subnets         = data.terraform_remote_state.project-core.outputs.subnets
  certificate_arn = data.aws_acm_certificate.programmers_only.arn

  target_group = [
    {
      arn      = "arn:::sample"
      hostname = "dummy.programmers-only.com"
    }
  ]

}
