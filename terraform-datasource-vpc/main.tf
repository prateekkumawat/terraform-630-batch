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
  secret_key = "xxxxx"
  access_key = "xxxxx"
}


data "aws_vpc" "project-vpc" {
  cidr_block = "10.0.0.0/16"
}

data "aws_subnet" "pspub1az1" { 
    id = "subnet-0f45ee452527c2298"
}

data "aws_subnet" "pspub2az2" { 
    id = "subnet-03018d942d6299043"
}

data "aws_subnet" "pspri1az1" { 
    id = "subnet-058f525e10484e4d9"
}

data "aws_subnet" "pspri2az2" { 
    id = "subnet-0a89ee31afe5e52ec"
}

#crate a public server in predefine vpc
resource "aws_instance" "hsitmanagementpublicserver" {
  ami = "ami-013e83f579886baeb"
  instance_type = "t2.small"
  key_name = "op"
  security_groups = [aws_security_group.hsitmanagmentpublicsg.id]
  subnet_id = data.aws_subnet.pspub1az1.id

  tags = {
    Name = "data-call-vpc-ins"
  }
}


# create security group for public servers
resource "aws_security_group" "hsitmanagmentpublicsg" {
  name        = "hsit-management-public-server-sg"
  description = "Security Group for public servers hsit-management-vpc "
  vpc_id = data.aws_vpc.project-vpc.id

    ingress {
      description = "Allow port ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Allow port http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
