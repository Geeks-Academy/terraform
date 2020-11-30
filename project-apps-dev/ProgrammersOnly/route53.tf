resource "aws_route53_zone" "private" {
  name = "programmers.only"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "www.programmers.only"
  type    = "CNAME"
  ttl     = "300"
  records = [module.ALB.alb_dns_name]
}

resource "aws_route53_record" "auth" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "auth.programmers.only"
  type    = "CNAME"
  ttl     = "300"
  records = [module.ALB.alb_dns_name]
}
