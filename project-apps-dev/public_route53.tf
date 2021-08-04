# Geeks Academy
data "aws_route53_zone" "geeks_academy_public" {
  name         = "geeks.academy."
  private_zone = false
}


resource "aws_route53_record" "geeks_academy_public" {
  for_each = local.public_geeks_academy_dns_entries

  zone_id = data.aws_route53_zone.geeks_academy_public.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = "300"
  records = [module.GeeksAcademy.alb_dns_name]
}

resource "aws_route53_record" "structure" {
  zone_id = data.aws_route53_zone.geeks_academy_public.zone_id
  name    = "structure.geeks.academy"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.structure.domain_name
    zone_id                = aws_cloudfront_distribution.structure.hosted_zone_id
    evaluate_target_health = false
  }
}