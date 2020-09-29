### ECS CLUSTER
resource "aws_ecs_cluster" "programmers_only" {
  name = "ProgrammersOnly"
}

### ASG
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-*-amazon-ecs-optimized",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

data "template_file" "user_data" {
  template = "${file("userdata.sh")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
  }
}

resource "aws_launch_configuration" "programmers_only" {
  name_prefix                 = "programmers-only"
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  user_data                   = data.template_cloudinit_config.config.rendered
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  security_groups             = var.security_groups
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_size = 22
  }
}

resource "aws_autoscaling_group" "programmers_only" {
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
  name                 = "programmers-only"
  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.programmers_only.name
  min_size             = 0
  max_size             = 2
  desired_capacity     = 0

  tags = [
    {
      "key"                 = "Name"
      "value"               = format("%s-ecs", var.prefix)
      "propagate_at_launch" = true
    },
    {
      "key"                 = "EnvironmentType"
      "value"               = "dev"
      "propagate_at_launch" = true
    }
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

}

## ARTIFACTS ON S3

resource "aws_kms_key" "artifacts_kms_key" {
  description             = "This key is used to encrypt bucket objects"
}

resource "aws_kms_alias" "artifacts_kms_key_alias" {
  name          = "alias/artifacts_kms_key"
  target_key_id = aws_kms_key.artifacts_kms_key.key_id
}

resource "aws_s3_bucket" "programmers_only_artifacts" {
  bucket = "programmers-only-artifacts"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.artifacts_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}