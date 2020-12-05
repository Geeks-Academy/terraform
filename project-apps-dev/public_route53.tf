data "aws_route53_zone" "public" {
  name         = "programmers-only.com."
  private_zone = false
}


resource "aws_route53_record" "public" {
  for_each = local.public_dns_entries

  zone_id = data.aws_route53_zone.public.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = "300"
  records = [module.ProgrammersOnly.alb_dns_name]
}
