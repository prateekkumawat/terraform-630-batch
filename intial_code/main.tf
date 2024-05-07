# add terraform aws provider 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

# configure aws terraform providers
provider "aws" {
     region     = var.aws_region
     access_key = var.aws_access_key
     secret_key = var.aws_secret_key
     
}

# aws vpc create for test example
resource "aws_vpc" "test" {
  cidr_block = var.vpc_network
  tags = {
    Name = var.projectname
  }
}

# create a subnet in test vpc 
resource "aws_subnet" "testsubnet1" {
  vpc_id = aws_vpc.test.id
  cidr_block = var.subnet_network[0]
  availability_zone = var.azzone[0]
  tags = { 
    Name = "test-vpc-terraform-az1-subnet1"
  }
}

# create a subnet in test vpc 
resource "aws_subnet" "testsubnet2" {
  vpc_id = aws_vpc.test.id
  cidr_block = var.subnet_network[1]
  availability_zone = var.azzone[1]
  tags = { 
    Name = "test-vpc-terraform-az2-subnet2"
  }
}

# create a subnet in test vpc 
resource "aws_subnet" "testsubnet3" {
  vpc_id = aws_vpc.test.id
  cidr_block = var.subnet_network[2]
  availability_zone = var.azzone[2]
  tags = { 
    Name = "test-vpc-terraform-az3-subnet3"
  }
}