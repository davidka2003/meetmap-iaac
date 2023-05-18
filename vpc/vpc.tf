variable "app_prefix" {
  type    = string
  default = "meetmap-backend"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.app_prefix
  }
}


resource "aws_subnet" "public-eu-west-1a" {
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.app_prefix}-subnet-public-eu-west-1a"
  }
}

resource "aws_subnet" "public-eu-west-1b" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1b"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.app_prefix}-subnet-public-eu-west-1b"
  }
}


resource "aws_subnet" "private-eu-west-1a" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1a"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.app_prefix}-subnet-private-eu-west-1a"
  }
}

resource "aws_subnet" "private-eu-west-1b" {
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1b"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.app_prefix}-subnet-private-eu-west-1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_prefix}-internet-gateway"
  }
}

resource "aws_eip" "nat-eu-west-1a" {
  vpc = true

  tags = {
    Name = "Elastic Ip for Nat gateway eu-west-1a"
  }
}

resource "aws_eip" "nat-eu-west-1b" {
  vpc = true

  tags = {
    Name = "Elastic Ip for Nat gateway eu-west-1b"
  }
}

resource "aws_nat_gateway" "private-eu-west-1a" {
  allocation_id = aws_eip.nat-eu-west-1a.id
  subnet_id     = aws_subnet.private-eu-west-1a.id

  tags = {
    Name = "Nat gateway eu-west-1a"
  }
}

resource "aws_nat_gateway" "private-eu-west-1b" {
  allocation_id = aws_eip.nat-eu-west-1b.id
  subnet_id     = aws_subnet.private-eu-west-1b.id

  tags = {
    Name = "Nat gateway eu-west-1b"
  }
}

resource "aws_route" "private_nat_gateway-1a" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.private-eu-west-1a.id
}

resource "aws_route" "private_nat_gateway-1b" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.private-eu-west-1b.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.app_prefix}-rtb-public"
  }
}

resource "aws_route_table_association" "public-eu-west-1a" {
  subnet_id      = aws_subnet.public-eu-west-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-1b" {
  subnet_id      = aws_subnet.public-eu-west-1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_prefix}-rtb-private"
  }
}

resource "aws_route_table_association" "private-eu-west-1a" {
  subnet_id      = aws_subnet.private-eu-west-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-1b" {
  subnet_id      = aws_subnet.private-eu-west-1b.id
  route_table_id = aws_route_table.private.id
}
