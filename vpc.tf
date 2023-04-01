resource "aws_vpc" "Dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Dev-vpc"
  }
}

resource "aws_subnet" "az1" {
  vpc_id                  = aws_vpc.Dev-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet for us-east-1a"
  }
}

resource "aws_subnet" "az2" {
  vpc_id                  = aws_vpc.Dev-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet for us-east-1b"
  }
}

resource "aws_subnet" "az3" {
  vpc_id                  = aws_vpc.Dev-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet for us-east-1c"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Dev-vpc.id
}

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.Dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod-route-table"
  }
}
resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.az1.id
    route_table_id = aws_route_table.prod-route-table.id
}
resource "aws_route_table_association" "b" {
    subnet_id      = aws_subnet.az2.id
    route_table_id = aws_route_table.prod-route-table.id
}
resource "aws_route_table_association" "c" {
    subnet_id      = aws_subnet.az3.id
    route_table_id = aws_route_table.prod-route-table.id
}


resource "aws_security_group" "allow_web" {
  name        = "allow_tls"
  description = "Allow web inbound traffic"
  vpc_id      =  aws_vpc.Dev-vpc.id

  ingress {
    description        = "HTTPS"
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

 ingress {
    description        = "HTTP"
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description        = "SSH"
    from_port          = 22
    to_port            = 22

    protocol           = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}