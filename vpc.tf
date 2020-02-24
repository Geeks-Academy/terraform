resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    "Name"            = format("%s-VPC", local.name)
    "EnvironmentType" = var.environment_type
    "Managed by"      = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"            = format("%s-IGW", local.name)
    "EnvironmentType" = var.environment_type
    "Managed by"      = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"
  cidr_block              = var.public_subnet_cidr

  tags = {
    "Name"            = format("%s-Public", local.name)
    "EnvironmentType" = var.environment_type
    "Managed by"      = "Terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id

  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"
  cidr_block              = var.private_subnet_cidr

  tags = {
    "Name"            = format("%s-Private", local.name)
    "EnvironmentType" = var.environment_type
    "Managed by"      = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"            = format("%s-Public-RT", local.name)
    "EnvironmentType" = var.environment_type
    "Managed by"      = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"            = format("%s-Private-RT", local.name)
    "EnvironmentType" = var.environment_type
    "Managed by"      = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

