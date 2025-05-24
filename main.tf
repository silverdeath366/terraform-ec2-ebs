provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = "us-east-1c"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_internet_gateway.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-access"
  description = "Allow SSH from trusted IP"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "ingress_rules" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["<your-ip>/32"]  #  place here your real ip
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1c"
  size              = 1
}

resource "aws_instance" "ec2_vpc" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1c"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = "flask-nginx-key"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              mkfs -t ext4 /dev/xvdf
              mkdir /mnt/data
              mount /dev/xvdf /mnt/data
              echo "/dev/xvdf /mnt/data ext4 defaults,nofail 0 2" >> /etc/fstab
            EOF
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.ec2_vpc.id
}
