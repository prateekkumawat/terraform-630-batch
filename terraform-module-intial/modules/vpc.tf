# create a vpc for aws project 
resource "aws_vpc" "hsitmanagementvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
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

# crate a subnet2 for private
resource "aws_subnet" "hsitmanagementsubnet2" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.hsitmanagementvpc.id
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "hsit-management-private1-az2"
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
