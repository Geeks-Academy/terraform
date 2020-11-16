### ALB
data "aws_acm_certificate" "programmers_only" {
  domain   = "*.programmers-only.com"
  statuses = ["ISSUED"]
}


module "ALB" {
  source = "../../modules/ALB"

  name            = "programmers-only"
  security_groups = var.alb_security_groups
  subnets         = join(", ", [element(var.public_subnets, 0), element(var.private_subnets, 0)])
  certificate_arn = data.aws_acm_certificate.programmers_only.arn

  target_groups = [
    {
      hostname     = "www.programmers-only.com"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 100
      path         = "/"
    },
    {
      hostname     = "www.programmers.only"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 300
      path         = "/"
    }
  ]

}
