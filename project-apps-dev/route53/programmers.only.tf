resource "aws_route53_zone" "private" {
  name = "programmers.only"

  vpc {
    vpc_id = var.vpc_id
  }
}

output "private_zone_id" {
  value = aws_route53_zone.private.zone_id
}
