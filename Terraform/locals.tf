locals {
  vpc-id     = aws_vpc.ALL.id
  anywhere   = "0.0.0.0/0"
  mysql-port = "3306"
  tcp        = "tcp"
  ssh-port   = 22
  http-port  = 80
}