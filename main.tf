provider "aws" {
  region = var.my_region
}

#In these Particular Resource we have created 
# VPC inside which there 2 subnets called as public and private subnet

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/22"
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "my_public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/23"

  tags = {
    Name = "my_public_subnet"
  }
}

resource "aws_subnet" "my_private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/23"

  tags = {
    Name = "my_private_subnet"
  }
}

resource "aws_internet_gateway" "my_Internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_Internet_Gateway"
  }
}

resource "aws_internet_gateway_attachment" "my_ig-to-vpc" {
  internet_gateway_id = aws_internet_gateway.my_Internet_gateway.id
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_public_route_table"
  }
}

resource "aws_route_table_association" "my-rt-to-subnet" {
  route_table_id = aws_route_table.my_public_route_table.id
  subnet_id = aws_subnet.my_public_subnet.id
}

resource "aws_route" "my_route_public_1" {
  route_table_id = aws_route_table.my_public_route_table.id
  destination_cidr_block = aws_subnet.my_public_subnet.cidr_block
  gateway_id = aws_internet_gateway.my_Internet_gateway.id
}

resource "aws_route" "my_route_public_2" {
  route_table_id = aws_route_table.my_public_route_table.id
  destination_cidr_block = aws_subnet.my_public_subnet.id
  gateway_id = "local"
}



resource "aws_route_table" "my_private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route = {
    cidr_block="10.0.0.0/23"
    gateway_id="local"
  }
}