resource "aws_subnet" "public_subnet" {
    cidr_block = var.public_subnet_cidr
    vpc_id     = aws_vpc.vpc.id

    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    cidr_block = var.private_subnet_cidr
    vpc_id     = aws_vpc.vpc.id

    tags = {
        Name = "private-subnet"
    }
}

resource "aws_security_group" "ec2_sg" {
    name        = "ec2-security-group"
    description = "Allow SSH and HTTP traffic"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["YOUR_PUBLIC_IP/32"]
    }

    ingress {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

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
