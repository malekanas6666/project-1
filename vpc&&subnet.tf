resource "aws_vpc" "net" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.net.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.net.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "frontend" {
  vpc_id     = aws_vpc.net.id
  availability_zone   = "eu-central-1a"
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "frontend"
  }
}

resource "aws_subnet" "backend" {
  vpc_id     = aws_vpc.net.id
    availability_zone   = "eu-central-1b"
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "backend"
  }
}
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]

  tags = {
    Name = "My DB subnet group"
  }
}
