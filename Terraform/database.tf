resource "aws_security_group" "DATABASE" {
  vpc_id = local.vpc-id
  ingress {
    from_port   = local.mysql-port
    to_port     = local.mysql-port
    protocol    = local.tcp
    cidr_blocks = [var.ALL-VPC-INFO.vpc-cidr]
  }
  tags = {
    Name = "DATABASE"
  }
  depends_on = [
    aws_subnet.SUBNETS
  ]
}

data "aws_subnets" "db" {
  filter {
    name   = "tag:Name"
    values = var.ALL-VPC-INFO.db-subnets
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc-id]
  }
  depends_on = [
    aws_subnet.SUBNETS
  ]
}

resource "aws_db_subnet_group" "db" {

  name       = "db"
  subnet_ids = data.aws_subnets.db.ids ##QUERYING THE DB-SUBNETS FROM DATA RESOURCE
  depends_on = [
    aws_subnet.SUBNETS
  ]
}

resource "aws_db_instance" "emd" {
  allocated_storage      = "20"
  db_name                = "rr"
  db_subnet_group_name   = "db"
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t2.micro"
  username               = "this"
  password               = "krishna12345"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.DATABASE.id]
  skip_final_snapshot    = true

  depends_on = [
    aws_db_subnet_group.db,
    aws_security_group.DATABASE
  ]
}