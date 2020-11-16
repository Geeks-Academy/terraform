### EC2
resource "aws_security_group" "ecs" {
  name   = "allow_ec2_traffic"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ecs_allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_allow_alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id

  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs.id
}

### ALB
resource "aws_security_group" "alb" {
  name   = "SG-alb"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ecs_allow_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_allow_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs.id
}
