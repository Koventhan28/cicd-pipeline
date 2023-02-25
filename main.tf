resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpccidrblock
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ec2_vpc-${var.project}"
  }
}
resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.publicsubnet
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public-${var.project}"
  }
}
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-igw-${var.project}"
  }
}
resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev_public_rt-${var.project}"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}
resource "aws_route_table_association" "my_public_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_rt.id
}
resource "aws_security_group" "my_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_key_pair" "my_auth" {
  key_name   = "my_key"
  public_key = file("/home/koventhan/.ssh/id_rsa.pub")
}
resource "aws_instance" "ec2_dev" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.my_public_subnet.id
  key_name               = aws_key_pair.my_auth.id
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "jenkins-agent-node-${var.project}"
  }
}