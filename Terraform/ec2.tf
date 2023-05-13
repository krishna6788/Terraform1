resource "aws_security_group" "inst" {
  vpc_id = local.vpc-id
  ingress {
    from_port   = local.ssh-port
    to_port     = local.ssh-port
    protocol    = local.tcp
    cidr_blocks = [local.anywhere]
  }
  ingress {
    from_port   = local.http-port
    to_port     = local.http-port
    protocol    = local.tcp
    cidr_blocks = [local.anywhere]
  }
  ingress {
    from_port   = 8080 ##THIS INGRESS IS FOR JENKINS
    to_port     = 8080
    protocol    = local.tcp
    cidr_blocks = [local.anywhere]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.anywhere]
  }

  tags = {
    Name = "inst"
  }
  depends_on = [
    aws_vpc.ALL
  ]
}

data "aws_subnet" "web" {
  filter {
    name   = "tag:Name"
    values = [var.ALL-VPC-INFO.web-ec2-subnet]
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc-id]
  }
}

resource "aws_instance" "hey" {
  ami                         = "ami-007855ac798b5175e"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.web.id
  associate_public_ip_address = "true"
  key_name                    = "ssh-key"
  vpc_security_group_ids      = [aws_security_group.inst.id]
  user_data                   = file("apache.sh")


  tags = {
    Name = "hey"
  }
  depends_on = [
    aws_security_group.inst,

  ]

}