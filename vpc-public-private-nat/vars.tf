variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "vpc_cidr_network" {}
variable "vpc_subnet_cidr" {
  type = list 
}
variable "vpc_subnet_az" {
 type = list  
}
variable "aws_ami" {}
variable "aws_instance_type" {}