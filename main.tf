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
  map_public_ip_on_launch = true

  tags = {
    Name = "my_public_subnet"
  }
}

resource "aws_subnet" "my_private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/23"

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

# resource "aws_internet_gateway_attachment" "my_ig-to-vpc" {
#   internet_gateway_id = aws_internet_gateway.my_Internet_gateway.id
#   vpc_id = aws_vpc.my_vpc.id

#   # depends_on = [ aws_internet_gateway.my_Internet_gateway ]
# }

resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_public_route_table"
  }
}

resource "aws_route_table_association" "my-rt-to-subnet-public" {
  route_table_id = aws_route_table.my_public_route_table.id
  subnet_id = aws_subnet.my_public_subnet.id
}

resource "aws_route" "my_route_public_1" {
  route_table_id = aws_route_table.my_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_Internet_gateway.id
}

# resource "aws_route" "my_route_public_2" {
#   route_table_id = aws_route_table.my_public_route_table.id
#   destination_cidr_block = aws_subnet.my_public_subnet.cidr_block
#   gateway_id = "local"
# }



resource "aws_route_table" "my_private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_private_route_table"
  }
}

resource "aws_route_table_association" "my-rt-to-subnet-private" {
  route_table_id = aws_route_table.my_private_route_table.id
  subnet_id = aws_subnet.my_private_subnet.id
}

# resource "aws_route" "my_route_private_1" {
#   route_table_id = aws_route_table.my_private_route_table.id
#   destination_cidr_block = aws_subnet.my_private_subnet.cidr_block
#   gateway_id = "local"
# }

resource "aws_security_group" "public_EC2" {
  name = "Allow SSh and http"
  description = "Allow all the traffic comming from open network"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "my_sg_public_ec2_outbound" {
  security_group_id = aws_security_group.public_EC2.id

  cidr_ipv4 = aws_subnet.my_public_subnet.cidr_block
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "my_sg_public_ec2_inboud" {
  security_group_id = aws_security_group.public_EC2.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_security_group" "private_ec2" {
  name = "Allow access from public"
  description = "Allow all the traffic comming from public subnet"

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "allow_access_from_public"
  }
}

resource "aws_vpc_security_group_egress_rule" "my_sg_private_ec2_outbound" {
  security_group_id = aws_security_group.private_ec2.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "my_sg_private_ec2_outbound" {
  security_group_id = aws_security_group.private_ec2.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  referenced_security_group_id = aws_security_group.public_EC2.id 
}

resource "aws_instance" "public_ec2_instance" {
  ami = var.my_ami
  instance_type = var.my_instance
  subnet_id = aws_subnet.my_public_subnet.id
  security_groups = [aws_security_group.public_EC2.id]
  key_name = "key-pair-p"
}


resource "aws_instance" "private_ec2_instance" {
  ami = var.my_ami
  instance_type = var.my_instance
  subnet_id = aws_subnet.my_private_subnet.id
  security_groups = [aws_security_group.private_ec2.id]
  key_name = "key-pair-p"
}

# resource "aws_network_interface" "myinterface" {
#   security_groups = [aws_sec]
# }