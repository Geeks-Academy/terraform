terraform {
  backend "s3" {
    bucket         = "statestf"
    region         = "eu-central-1"
    key            = "states/iam/terraform.tfstate"
    dynamodb_table = "trlock"
  }
}

provider "aws" {
  version = "~> 2.39"
  region  = var.aws_region
  profile = var.profile_name
}

module "roles" {
  source = "./roles"
}
