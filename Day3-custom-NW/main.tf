resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      Name="DEV_VPC"
    }
  
}
resource "aws_subnet" "public_subnet" {
    cidr_block = var.public_subnet_cidr
    vpc_id = aws_vpc.vpc.id
    tags ={
        Name="public_subnet"
    }
  
}
resource "aws_subnet" "private_subnet" {
    cidr_block = var.private_subnet_cidr
    vpc_id = aws_vpc.vpc.id
    tags={
        Name="private-subnet"
    }
  
}
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name="internet_gateway"
    }

  
}
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name="public_route"
    }
  
}
resource "aws_eip" "elastic" {
    domain = "vpc"
    tags = {
      Name="elastic_ip"
    }
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.elastic.id
    subnet_id = aws_subnet.public_subnet.id
    depends_on = [ aws_internet_gateway.ig ]
    tags={
        Name="NATTTT"
    }
}
resource "aws_route_table" "private-route" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name="private_route"
    }
  
}
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

  # Allow SSH - Port 22
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP - Port 80
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-SG"
  }
}
resource "aws_route" "routing" {
    route_table_id = aws_route_table.public_route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
}

resource "aws_route" "routingss" {
    route_table_id = aws_route_table.private-route.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id


  
}
# Public Subnet Association
resource "aws_route_table_association" "assocation" {
    route_table_id = aws_route_table.public_route.id
    subnet_id      = aws_subnet.public_subnet.id
}

# Private Subnet Association
resource "aws_route_table_association" "assocationss" {
    route_table_id = aws_route_table.private-route.id
    subnet_id      = aws_subnet.private_subnet.id
}
resource "aws_instance" "public_ec2" {
    ami           = "ami-0e34b50e714a297f1"
    instance_type = "t3.micro"

    subnet_id = aws_subnet.public_subnet.id

    vpc_security_group_ids = [
        aws_security_group.ec2_sg.id
    ]

    associate_public_ip_address = true

    key_name = "mykeypair"

    tags = {
        Name = "public-ec2"
    }
}