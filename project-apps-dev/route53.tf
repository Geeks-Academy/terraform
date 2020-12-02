resource "aws_route53_zone" "private" {
  name = "programmers.only"

  vpc {
    vpc_id = data.terraform_remote_state.project-core.outputs.vpc_common_id
  }
}

resource "aws_route53_record" "auth" {
  for_each = local.private_dns_entries

  zone_id = aws_route53_zone.private.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = "300"
  records = [module.ProgrammersOnly.alb_dns_name]
}
