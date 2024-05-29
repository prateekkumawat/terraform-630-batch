# create a vpc for aws project 
resource "aws_vpc" "hsitmanagementvpcprod" {
  cidr_block = "172.30.0.0/22"
  instance_tenancy = "default"
  tags = {
    Name = "hsit-manangement-vpc-prod"
  }
}

# crate a subnet1 for public
resource "aws_subnet" "hsitmanagementsubnet1prod" {
  cidr_block = "172.30.1.0/24"
  vpc_id = aws_vpc.hsitmanagementvpcprod.id
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "hsit-management-public1-az1-prod"
  }
}

# crate a subnet2 for private
resource "aws_subnet" "hsitmanagementsubnet2prod" {
  cidr_block = "172.30.2.0/24"
  vpc_id = aws_vpc.hsitmanagementvpcprod.id
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "hsit-management-private1-az2-prod"
  }
}


# create a internet gateway for vpc 
resource "aws_internet_gateway" "hsitmanagementigwprod" {
  vpc_id = aws_vpc.hsitmanagementvpcprod.id

  tags = {
    Name = "hsit-management-vpc-igw-prod"
  }
}

# create a public route table for managmement vpc
resource "aws_route_table" "hsitmanagenmentpublicrtprod" {
  vpc_id = aws_vpc.hsitmanagementvpcprod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hsitmanagementigwprod.id
  }
  tags = {
    Name = "hsit-managment-public-rt-prod"
  }
}

# crate a subnet assosiation for public rt
resource "aws_route_table_association" "publicrtsubnet1assosiationprod" {
  subnet_id      = aws_subnet.hsitmanagementsubnet1prod.id
  route_table_id = aws_route_table.hsitmanagenmentpublicrtprod.id
}
