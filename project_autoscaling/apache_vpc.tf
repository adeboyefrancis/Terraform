# VPC for Apache Webserver ASG
resource "aws_vpc" "main" {
  cidr_block       = "${var.cidr-block}"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    name = "${var.project-apache}-vpc"
  }
}

# Public Subnets Apache
resource "aws_subnet" "public_subnet1_apache" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.72.0.0/20"
    availability_zone = "eu-west-1a"

    tags = {
      name = "${var.project-apache}-public-subnet-1"
    }

}

resource "aws_subnet" "public_subnet2_apache" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.72.16.0/20"
    availability_zone = "eu-west-1b"

    tags = {
      name = "${var.project-apache}-public-subnet-2"
    }

}

# Internet Gateway , RT & RTA
resource "aws_internet_gateway" "igw-apache" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    name = "${var.project-apache}-igw-apache"
  }
}

resource "aws_route_table" "public-rt-apache" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-apache.id
  }

 tags = {
    name = "${var.project-apache}-public-rt-apache"
  }
}

resource "aws_route_table_association" "public-rta-apache-1" {
  subnet_id = aws_subnet.public_subnet1_apache.id
  route_table_id = aws_route_table.public-rt-apache.id
}

resource "aws_route_table_association" "public-rta-apache-2" {
  subnet_id = aws_subnet.public_subnet2_apache.id
  route_table_id = aws_route_table.public-rt-apache.id
}

# Private Subnets Apache
resource "aws_subnet" "private_subnet1_apache" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.72.128.0/20"
    availability_zone = "eu-west-1a"
    tags = {
      name = "${var.project-apache}-private-subnet-1"
    }

}

resource "aws_subnet" "private_subnet2_apache" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.72.144.0/20"
    availability_zone = "eu-west-1b"
    tags = {
      name = "${var.project-apache}-private-subnet-2"
    }

}

# EIP, NAT Gateway, RT & RTA
resource "aws_eip" "nat-eip-apache" {
    domain = "vpc"
 tags = {
      name = "${var.project-apache}-nat-eip"
    } 
}

resource "aws_nat_gateway" "natgw-apache" {
    allocation_id = aws_eip.nat-eip-apache.id
    subnet_id = aws_subnet.public_subnet1_apache.id

    depends_on = [aws_internet_gateway.igw-apache]  
}

resource "aws_route_table" "private-rt-apache" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-apache.id
  }

 tags = {
    name = "${var.project-apache}-private-rt-apache"
  }
}

resource "aws_route_table_association" "private-rta-apache-1" {
  subnet_id      = aws_subnet.private_subnet1_apache.id
  route_table_id = aws_route_table.private-rt-apache.id
}

resource "aws_route_table_association" "private-rta-apache-2" {
  subnet_id      = aws_subnet.private_subnet2_apache.id
  route_table_id = aws_route_table.private-rt-apache.id
}