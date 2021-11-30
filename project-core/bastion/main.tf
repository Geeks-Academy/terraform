### ASG
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-ecs-gpu-hvm-*-x86_64-ebs",
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
  template = file("userdata.sh")
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

resource "aws_launch_configuration" "bastion_geeks_academy" {
  name_prefix   = "bastion-geeks-academy"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #  spot_price                  = "0.0161"
  user_data                   = data.template_cloudinit_config.config.rendered
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  security_groups             = tolist([aws_security_group.bastion.id])
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_autoscaling_group" "bastion_geeks_academy" {
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
  name                 = "bastion-geeks-academy"
  vpc_zone_identifier  = tolist([element(var.public_subnets, 0), element(var.public_subnets, 1)])
  launch_configuration = aws_launch_configuration.bastion_geeks_academy.name
  min_size             = 0
  max_size             = 1
  desired_capacity     = 0

  tags = [
    {
      "key"                 = "Name"
      "value"               = format("bastion-%s", var.prefix)
      "propagate_at_launch" = true
    },
    {
      "key"                 = "EnvironmentType"
      "value"               = "dev"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "Managed by"
      "value"               = "Terraform"
      "propagate_at_launch" = true
    }
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

}
