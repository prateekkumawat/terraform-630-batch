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
  region = "ap-south-1"
  secret_key = "xxxx"
  access_key = "xxxx"
}

resource "aws_s3_bucket" "mybucket" {
   count = 3 
   bucket =  "mybucket-we"
   tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}