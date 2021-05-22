resource "aws_internet_gateway" "chatapp-igw" {
  vpc_id = aws_vpc.chatapp-vpc.id
  tags = {
    Name = "chatapp-igw"
  }
}

resource "aws_route_table" "chatapp-public-crt" {
  vpc_id = aws_vpc.chatapp-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.chatapp-igw.id
  }

  tags = {
    Name = "chatapp-public-crt"
  }
}

resource "aws_route_table_association" "chatapp-crta-public-subnet-1" {
  subnet_id      = aws_subnet.chatapp-subnet-public-1.id
  route_table_id = aws_route_table.chatapp-public-crt.id
}

resource "aws_route_table_association" "chatapp-crta-public-subnet-2" {
  subnet_id      = aws_subnet.chatapp-subnet-public-2.id
  route_table_id = aws_route_table.chatapp-public-crt.id
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.chatapp-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // This means, all ip address are allowed to ssh ! 
    // Put only your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Giving access to node port  5000
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh-allowed"
  }
}

resource "aws_security_group" "elb-http" {
  vpc_id = aws_vpc.chatapp-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "elb-http"
  }
}