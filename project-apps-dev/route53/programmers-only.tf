data "aws_route53_zone" "programmers_only" {
  name         = "programmers-only.com."
  private_zone = false
}

resource "aws_route53_record" "programmers_only" {
  zone_id = data.aws_route53_zone.programmers_only.zone_id
  name    = "programmers-only.com"
  type    = "A"
  ttl     = "300"
  records = ["52.58.100.247"]
}

resource "aws_route53_record" "www_programmers_only" {
  zone_id = data.aws_route53_zone.programmers_only.zone_id
  name    = "www.programmers-only.com"
  type    = "A"
  ttl     = "300"
  records = ["52.58.100.247"]
}
