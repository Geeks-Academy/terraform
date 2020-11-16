### ALB
data "aws_acm_certificate" "programmers_only" {
  domain   = "*.programmers-only.com"
  statuses = ["ISSUED"]
}


module "ALB" {
  source = "../../modules/ALB"

  name            = "programmers-only"
  security_groups = var.alb_security_groups
  subnets         = var.public_subnets
  certificate_arn = data.aws_acm_certificate.programmers_only.arn

  target_groups = {
    "www.programmers-only.com" = aws_alb_target_group.frontend.arn
  }

}
