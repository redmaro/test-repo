# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
}

# Subnets
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name        = "${var.project_name}-${var.vpc_name}-${var.env}-subnet-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name        = "${var.project_name}-${var.env}-subnet-public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name        = "${var.project_name}-${var.env}-subnet-private1"
  }
}



# Gateways
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.env}-igw1"
  }
}

resource "aws_eip" "nat1" {
  domain = "vpc"
  tags = {
    Name        = "${var.project_name}-${var.env}-eip-nat1"
  }
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name        = "${var.project_name}-${var.env}-nat-gateway1"
  }
}



# Routing
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.env}-route-table-public1"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.env}-route-table-private1"
  }
}

resource "aws_route" "public1" {
  route_table_id         = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw1.id
}

resource "aws_route" "private1" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat1.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}
