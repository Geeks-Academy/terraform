### ALB
data "aws_acm_certificate" "geeks_academy" {
  domain   = "*.geeks.academy"
  statuses = ["ISSUED"]
}


module "ALB" {
  source = "../../modules/ALB"

  name             = "geeks-academy"
  security_groups  = var.alb_security_groups
  subnets          = tolist([element(var.public_subnets, 0), element(var.public_subnets, 1)])
  certificate_arn  = data.aws_acm_certificate.geeks_academy.arn
  certificate_arns = []
  create_ssl       = true

  ssl_target_groups = [
    {
      priority = 130

      actions = [{
        type         = "forward"
        target_group = aws_alb_target_group.geeks_frontend.arn
      }]

      conditions = [{
        hostname = ["www.geeks.academy"]
      }]
    },
    {
      priority = 140

      actions = [{
        type         = "forward"
        target_group = aws_alb_target_group.geeks_frontend.arn
      }]

      conditions = [{
        hostname = ["geeks.academy"]
      }]
    },
    {
      priority = 150

      actions = [{
        type         = "forward"
        target_group = aws_alb_target_group.structure_backend.arn
      }]

      conditions = [{
        hostname = ["structure-api.geeks.academy"]
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
