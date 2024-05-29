variable "vpcs" {
  type = map(object({
    cidr_block = string
    name = string
    tags = map(string)
  }))
  default = {
    "vpc1" = {
      cidr_block = "10.0.0.0/22"
      name = "prod"
      tags = {
        Name = "prod"
      }
    }
    "vpc2" = {
        cidr_block = "10.0.4.0/22"
        name = "dev"
        tags = { 
            Name = "dev"
        }
    }
  }
}

variable "subnets" {
  type = map(object({
    subnet_cidr = string
    subnet_az = string 
    vpc_name = string
  }))

  default = {
    "public1" = {
      subnet_az = "ap-south-1a"
      subnet_cidr = "10.0.1.0/24"
      vpc_name = "vpc1"
    }
    "public2" = { 
      subnet_az = "ap-south-1a"
      subnet_cidr = "10.0.4.0/24"
      vpc_name = "vpc2"
    }
  }
  
}