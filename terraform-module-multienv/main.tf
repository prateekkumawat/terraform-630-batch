terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

# create aws provider 
provider "aws" {
  region = var.aws_region
  secret_key = var.aws_secret_key
  access_key = var.aws_access_key
}

module "hsitdev" {
  source = "./modules/project-hsit-dev"
}

module "hsitprod" {
  source = "./modules/project-hsit-prod"
}