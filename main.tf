terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
#######################################################
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

resource "aws_security_group" "Wordpress_SG" {
  vpc_id = aws_vpc.Wordpress_VPC.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Wordpress-sg"
  }
}
#######################################################