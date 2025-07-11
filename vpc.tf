resource "aws_vpc" "Wordpress_VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Wordpress-VPC"
  }
}

resource "aws_internet_gateway" "Wordpress_IG" {
  vpc_id = aws_vpc.Wordpress_VPC.id

  tags = {
    Name = "Wordpress-Ig"
  }
}

resource "aws_subnet" "Wordpress_subnet_1" {
  vpc_id     = aws_vpc.Wordpress_VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Wordpress-subnet-01"
  }
}

resource "aws_route_table" "Wordpress_RT" {
  vpc_id = aws_vpc.Wordpress_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Wordpress_IG.id
  }

  tags = {
    Name = "Wordpress-public-rt"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Wordpress_subnet_1.id
  route_table_id = aws_route_table.Wordpress_RT.id
}