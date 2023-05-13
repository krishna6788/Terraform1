resource "aws_security_group" "sg" {
  vpc_id = local.vpc-id

  ingress {
    from_port   = local.http-port
    to_port     = local.http-port
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
    Name = "sg"
  }

}


resource "aws_lb" "loadb" {

  name               = "FIRST"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [for subnet in aws_subnet.SUBNETS : subnet.id] #QUERING THE THIS INFORMATION FROM DATA
  depends_on = [
    aws_instance.hey
  ]
}

resource "aws_lb_listener" "LISTNER" {
  load_balancer_arn = aws_lb.loadb.arn #CREATION OF LISTNER FOR LOAD BALANCER#
  port              = local.http-port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }

}

resource "aws_lb_target_group" "TG" {
  port     = local.http-port
  protocol = "HTTP"
  vpc_id   = local.vpc-id
  depends_on = [
    aws_vpc.ALL,
    aws_instance.hey
  ]
}

resource "aws_lb_target_group_attachment" "tga" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.hey.id
  port             = 80
}