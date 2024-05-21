terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "terraform-hsit-state"
    key    = "state"
    region = "ap-south-1"
  }
}

# create a vpc for aws project 
resource "aws_vpc" "hsitmanagementvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  lifecycle {
    prevent_destroy =  false
    }
  tags = {
    Name = "hsit-manangement-vpc"
  }
}

# crate a subnet1 for public
resource "aws_subnet" "hsitmanagementsubnet1" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.hsitmanagementvpc.id
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "hsit-management-public1-az1"
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

# crate a subnet assosiation for public rt
resource "aws_route_table_association" "publicrtsubnet1assosiation" {
  subnet_id      = aws_subnet.hsitmanagementsubnet1.id
  route_table_id = aws_route_table.hsitmanagenmentpublicrt.id
}

# Genrate a key for Instance  
resource "tls_private_key" "hsitpublic_key" {
  algorithm = "RSA"
  rsa_bits  = 4096 
}
resource "aws_key_pair" "hsitpublic_key_pair" {
  key_name   = "hsitpublicins.pem"
  public_key = tls_private_key.hsitpublic_key.public_key_openssh
}
resource "local_file" "hsitpublicserverkey" {
   filename = "hsitpublicins.pem"
   content = tls_private_key.hsitpublic_key.private_key_pem
}


# crate a public server in vpc
resource "aws_instance" "hsitmanagementpublicserver" {
  ami = "ami-013e83f579886baeb"
  instance_type = "t2.small"
  key_name = aws_key_pair.hsitpublic_key_pair.key_name
  security_groups = [aws_security_group.hsitmanagmentpublicsg.id]
  subnet_id = aws_subnet.hsitmanagementsubnet1.id
  lifecycle {
    create_before_destroy  = true
    #prevent_destroy = true
    ignore_changes = all
  }
  tags = {
    Name = "hsit-management-public-server"
  }
}


# create security group for public servers
resource "aws_security_group" "hsitmanagmentpublicsg" {
  name        = "hsit-management-public-server-sg"
  description = "Security Group for public servers hsit-management-vpc "
  vpc_id = aws_vpc.hsitmanagementvpc.id

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

output "publicservereip" {
   value = aws_instance.hsitmanagementpublicserver.public_ip
}

output "privateserverip" {
  value = aws_instance.hsitmanagementpublicserver.private_ip
}
