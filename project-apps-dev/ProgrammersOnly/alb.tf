### ALB
data "aws_acm_certificate" "programmers_only" {
  domain   = "*.programmers-only.com"
  statuses = ["ISSUED"]
}


module "ALB" {
  source = "../../modules/ALB"

  name            = "programmers-only"
  security_groups = var.alb_security_groups
  subnets         = list(element(var.public_subnets, 0), element(var.public_subnets, 1))
  certificate_arn = data.aws_acm_certificate.programmers_only.arn

  ssl_target_groups = [
    {
      hostname     = "www.programmers-only.com"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 100
    },
    {
      hostname     = "programmers-only.com"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 110
    },
    {
      hostname     = "auth.programmers-only.com"
      target_group = aws_alb_target_group.auth.arn
      priority     = 120
    }
  ]

  target_groups = [
    {
      hostname     = "www.programmers-only.com"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 100
    },
    {
      hostname     = "programmers-only.com"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 110
    },
    {
      hostname     = "auth.programmers-only.com"
      target_group = aws_alb_target_group.auth.arn
      priority     = 120
    },
    {
      hostname     = "www.geeks.academy"
      target_group = aws_alb_target_group.geeks_frontend.arn
      priority     = 130
    },
    {
      hostname     = "new.geeks.academy"
      target_group = aws_alb_target_group.geeks_frontend.arn
      priority     = 140
    }
  ]

}
