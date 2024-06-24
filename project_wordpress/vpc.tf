# Create VPC for wordpress deployment
resource "aws_vpc" "main" {
    cidr_block = "${var.cidr-block}"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${var.project-wordpress}-my-vpc"
    }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.project-wordpress}-public-sub-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.project-wordpress}-public-sub-2"
  }
}

# Create Internet Gateway for Public Subnets
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project-wordpress}-internet-gw"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  tags = {
    Name = "${var.project-wordpress}-public-rt"
  }
}

# Create Route Table association for Public Subnets
resource "aws_route_table_association" "public-rta-1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-rta-2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.project-wordpress}-private-sub-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.144.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.project-wordpress}-private-sub-2"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat-eip" {
    domain = "vpc"
    tags = {
      name = "${var.project-wordpress}-nat-eip"
    }
}

# Create NAT gateway for Private Subnet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${var.project-wordpress}-nat-gw"
  }
  depends_on = [aws_internet_gateway.internet-gw]
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
  
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "${var.project-wordpress}-private-rt"
  }
}

# Create Route Table association for Private Subnets
resource "aws_route_table_association" "private-rta-1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-rta-2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}