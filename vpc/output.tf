output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet[0].id
}
