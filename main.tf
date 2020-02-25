module "vpc" {
  source = "./vpc"

  owner               = var.owner
  environment_type    = var.environment_type
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnet_cidr = var.private_subnet_cidr
  azs                 = var.azs
}

module "sg" {
  source = "./security"

  vpc_id = module.vpc.vpc_id
}
