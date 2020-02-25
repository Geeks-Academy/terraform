resource "aws_security_group" "ec2" {
  name   = "allow_ec2_traffic"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ec2_allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ec2_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2.id
}
