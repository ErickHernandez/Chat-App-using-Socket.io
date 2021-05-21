resource "aws_vpc" "chatapp-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "chatapp-vpc"
  }
}

resource "aws_subnet" "chatapp-subnet-public-1" {
  vpc_id                  = aws_vpc.chatapp-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = var.aws_availability_zone_a
  tags = {
    Name = "chatapp-subnet-public-1"
  }
}

resource "aws_subnet" "chatapp-subnet-public-2" {
  vpc_id                  = aws_vpc.chatapp-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = var.aws_availability_zone_b
  tags = {
    Name = "chatapp-subnet-public-2"
  }
}