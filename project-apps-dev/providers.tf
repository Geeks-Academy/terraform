provider "tls" {
  version = "2.1"
}

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
  profile = var.profile_name
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = var.profile_name
}
