resource "aws_security_group" "bastion" {
  name   = "allow_ec2_traffic"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "bastion_allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.bastion.id
}