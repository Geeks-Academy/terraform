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
      https_listener_index = 0
      priority     = 100

      actions = [{
        type         = "forward"
        target_group = aws_alb_target_group.frontend.arn
      }]

      conditions = [{
        path = ["/protected-route"]
        hostname = ["www.programmers-only.com"]
      }]
    }
  ]

  target_groups = [
    {
      hostname     = "www.programmers-only.com"
      path         = "/"
      target_group = aws_alb_target_group.frontend.arn
      priority     = 100
    }
  ]

}
