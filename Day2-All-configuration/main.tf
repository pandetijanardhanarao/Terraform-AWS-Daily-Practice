resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "My-vpc"
  }
}

resource "aws_subnet" "P_subnet" {
  cidr_block = "10.0.0.0/28"
  vpc_id     = aws_vpc.name.id

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "internetgateway"
  }
}

resource "aws_route_table" "p_rt" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "public-route"
  }
}

resource "aws_route" "p_rt" {
  route_table_id         = aws_route_table.p_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route_table_association" "association" {
  route_table_id = aws_route_table.p_rt.id
  subnet_id      = aws_subnet.P_subnet.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.0.16/28"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "NATT" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.P_subnet.id

  tags = {
    Name = "NATTTT"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "private-route"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NATT.id
}

resource "aws_route_table_association" "private_assoc" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.private_subnet.id
}