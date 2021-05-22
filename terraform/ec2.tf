resource "aws_instance" "chatapp1" {
  ami           = lookup(var.ami, var.aws_region)
  instance_type = "t2.micro"
  # Subnet
  subnet_id = aws_subnet.chatapp-subnet-public-1.id
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  # the Public SSH key
  key_name = aws_key_pair.chatapp-instance-key-pair.key_name

  provisioner "file" {
    source      = "../scripts/install_nodejs.sh"
    destination = "/tmp/install_nodejs.sh"
  }

  connection {
    host        = aws_instance.chatapp1.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../chatapp-instance-key-pair")
  }

  tags = {
    Name = "chatapp-1"
  }
}

resource "aws_instance" "chatapp2" {
  ami           = lookup(var.ami, var.aws_region)
  instance_type = "t2.micro"
  # Subnet
  subnet_id = aws_subnet.chatapp-subnet-public-2.id
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  # the Public SSH key
  key_name = aws_key_pair.chatapp-instance-key-pair.id

  provisioner "file" {
    source      = "../scripts/install_nodejs.sh"
    destination = "/tmp/install_nodejs.sh"
  }

  connection {
    host        = aws_instance.chatapp2.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../chatapp-instance-key-pair")
  }

  tags = {
    Name = "chatapp-2"
  }
}

# Defining key-pair to log in into chatapp instances
resource "aws_key_pair" "chatapp-instance-key-pair" {
  key_name   = "chatapp-instance-key-pair"
  public_key = file(var.public-ssh-key-path)
}