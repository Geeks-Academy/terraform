terraform {
  backend "s3" {
    profile = "irland"
    bucket  = "codebazar-states"
    region  = "eu-west-1"
    key     = "states/iam/terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 2.39"
  region  = var.aws_region
  profile = var.profile_name
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2_profile"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

output "instance_profile_ec2" {
  value = aws_iam_instance_profile.ec2.name
}
