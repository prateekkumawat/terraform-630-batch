terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# create a vpc for aws project 
resource "aws_vpc" "hsitmanagementvpc" {
  cidr_block = var.vpc_cidr_network
  instance_tenancy = "default"
  tags = {
    Name = "hsit-manangement-vpc"
  }
}


# crate a subnet2 for private
resource "aws_subnet" "hsitmanagementsubnet2" {
  cidr_block = var.vpc_subnet_cidr[1]
  vpc_id = aws_vpc.hsitmanagementvpc.id
  availability_zone = var.vpc_subnet_az[1]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "hsit-management-private2-az2"
  }
}

# crate a subnet1 for private
resource "aws_subnet" "hsitmanagementsubnet1" {
  cidr_block = var.vpc_subnet_cidr[0]
  vpc_id = aws_vpc.hsitmanagementvpc.id
  availability_zone = var.vpc_subnet_az[0]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "hsit-management-private1-az1"
  }
}

# create a internet gateway for vpc 
resource "aws_internet_gateway" "hsitmanagementigw" {
  vpc_id = aws_vpc.hsitmanagementvpc.id

  tags = {
    Name = "hsit-management-vpc-igw"
  }
}

# create a public route table for managmement vpc
resource "aws_route_table" "hsitmanagenmentpublicrt" {
  vpc_id = aws_vpc.hsitmanagementvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hsitmanagementigw.id
  }
  tags = {
    Name = "hsit-managment-public-rt"
  }
}

# create security group for public servers
resource "aws_security_group" "hsitmanagmentpublicsg" {
  name        = "hsit-management-db-server-sg"
  description = "Security Group for db servers hsit-management-vpc "
  vpc_id = aws_vpc.hsitmanagementvpc.id

    ingress {
      description = "Allow port ssh"
      from_port   = 3306
      to_port     = 3306
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

# create a DB subnet group 
resource "aws_db_subnet_group" "dbgrp" {
  name       = "hsit-db-management"
  subnet_ids = [aws_subnet.hsitmanagementsubnet1.id, aws_subnet.hsitmanagementsubnet2.id]

  tags = {
    Name = "hsit-db-subnet-group"
  }
}

# create a MySql RDS instance 
resource "aws_db_instance" "dbhsitgroup" {
  allocated_storage    = 20
  db_name              = "hsitprojectdb"
  identifier           = "hsitprojectdb" 
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Redhat123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.dbgrp.id
  vpc_security_group_ids = [aws_security_group.hsitmanagmentpublicsg.id]
}


output "db_connect_endpoint" {
  value = aws_db_instance.dbhsitgroup.endpoint
}