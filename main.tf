provider "aws" {
  region = var.my_region
}

#In these Particular Resource we have created 
# VPC inside which there 2 subnets called as public and private subnet

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/20"
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_route_table" "my_vpc_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  
}

