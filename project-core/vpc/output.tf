output "vpc_id" {
  value = aws_vpc.vpc.id
}

// TODO: check if it works
output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}
