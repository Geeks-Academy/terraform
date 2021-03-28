### ALB
data "aws_acm_certificate" "programmers_only" {
  domain   = "*.programmers-only.com"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "geeks_academy" {
  domain   = "*.geeks.academy"
  statuses = ["ISSUED"]
}


module "ALB" {
  source = "../../modules/ALB"

  name             = "geeks-academy"
  security_groups  = var.alb_security_groups
  subnets          = list(element(var.public_subnets, 0), element(var.public_subnets, 1))
  certificate_arn  = data.aws_acm_certificate.programmers_only.arn
  certificate_arns = [data.aws_acm_certificate.geeks_academy.arn]

  ssl_target_groups = [
    {
      hostname     = "www.programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 100
    },
    {
      hostname     = "programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 110
    },
    {
      hostname     = "auth.programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.auth.arn
      priority     = 120
    },
    {
      hostname     = "www.geeks.academy"
      path         = "/"
      target_group = aws_alb_target_group.geeks_frontend.arn
      priority     = 130
    },
    {
      hostname     = "new.geeks.academy"
      path         = "/"
      target_group = aws_alb_target_group.geeks_frontend.arn
      priority     = 140
    }
  ]

  target_groups = [
    {
      hostname     = "www.programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 100
    },
    {
      hostname     = "programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 110
    },
    {
      hostname     = "auth.programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.auth.arn
      priority     = 120
    },
    {
      hostname     = "www.geeks.academy"
      path         = "/"
      target_group = aws_alb_target_group.geeks_frontend.arn
      priority     = 130
    },
    {
      hostname     = "new.geeks.academy"
      path         = "/"
      target_group = aws_alb_target_group.geeks_frontend.arn
      priority     = 140
    },
    {
      hostname     = "structure.geeks.academy"
      path         = "/api/*"
      target_group = aws_alb_target_group.structure_backend.arn
      priority     = 150
    },
    {
      hostname     = "structure.geeks.academy"
      path         = "/"
      target_group = aws_alb_target_group.structure_frontend.arn
      priority     = 160
    }
  ]

}
