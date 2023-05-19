resource "aws_vpc" "meetmap-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "meetmap-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.meetmap-vpc.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.meetmap-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(["eu-west-1a", "eu-west-1b"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.meetmap-vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = element(["eu-west-1a", "eu-west-1b"], count.index)
  tags = {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.meetmap-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_main_route_table_association" "public_route_table_association" {
  vpc_id         = aws_vpc.meetmap-vpc.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.meetmap-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = 2
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
