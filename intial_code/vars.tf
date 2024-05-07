variable "aws_region" {
  type = string
  default = "ap-south-1"
  description = "enter your aws region"
}

variable "aws_secret_key" {
  type = string
  description = "enter your secret key "
}

variable "aws_access_key" {
  type = string
  description = "enter your access key "
}

variable "vpc_network" {
  type = string
}

variable "subnet_network" {
  type = list
}

variable "azzone" {
  type = list
}

variable "projectname" {
  type = string
}