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
  secret_key = "Bxxxx"
  access_key = "Axxxx"
}

resource "aws_vpc" "projectvpc" {
  for_each = var.vpcs
  cidr_block = each.value.cidr_block
  tags = merge(
    {
    Name = "hsit-project-vpc-${each.key}"
  },
   each.value.tags,
  )
}

resource "aws_subnet" "projectsubnet" {
  for_each = var.subnets
  vpc_id = aws_vpc.projectvpc[each.value.vpc_name].id
  cidr_block = each.value.subnet_cidr
  availability_zone = each.value.subnet_az
}


