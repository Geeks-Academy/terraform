data "aws_ssm_parameter" "linux" {
  name = "aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.linux.value
  instance_type               = var.type
  key_name                    = var.ssh_key
  subnet_id                   = var.subnet
  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.ec2_sg_id,
  ]

  tags = merge(
    map(
      "Name", format("%s-ec2", var.prefix),
    ),
    local.tags
  )
}
