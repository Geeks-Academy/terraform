provider "tls" {
  version = "2.1"
}

provider "aws" {
  version = "~> 2.39"
  region  = var.aws_region
  profile = var.profile_name
}

provider "azurerm" {
  features {}
}