
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.net.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.net.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id

  }
}
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.net.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id

  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.net.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id 
  }
}
resource "aws_route_table_association" "publicattach" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "frontattach" {
  subnet_id      = aws_subnet.frontend.id
  route_table_id = aws_route_table.private1.id
}
resource "aws_route_table_association" "backattach" {
  subnet_id      = aws_subnet.backend.id
  route_table_id = aws_route_table.private2.id
}