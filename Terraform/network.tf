resource "aws_vpc" "ALL" {
  cidr_block = var.ALL-VPC-INFO.vpc-cidr
  tags = {
    Name = "ALL"
  }
}

resource "aws_subnet" "SUBNETS" {
  count             = 6                                                                  ##USING COUNT
  cidr_block        = cidrsubnet(var.ALL-VPC-INFO.vpc-cidr, 8, count.index)              ##USING CIDRSUBNET FUNCTION
  availability_zone = "${var.region}${var.ALL-VPC-INFO.availability-zones[count.index]}" ##PASSINNG THE VARIABLES OF AVAILABILITY ZONES
  vpc_id            = local.vpc-id                                                       ## REDUSING THE EXPRESSION SIZE
  tags = {
    Name = var.ALL-VPC-INFO.subnet-names[count.index] ##PASSING THE VARIABLES OF SUBNET-NAMES
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = local.vpc-id ## REDUSING THE EXPRESSION SIZE

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc-id ## REDUSING THE EXPRISSION SIZE
  route {
    cidr_block = local.anywhere ## REDUSING THE EXPRISSION SIZE
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = local.vpc-id ## REDUSING THE EXPRISSION SIZE
  tags = {
    Name = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.ALL-VPC-INFO.public-subnets ##PASSING THE VARIABLES OF PUBLIC-SUBNETS
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc-id]
  }
  depends_on = [
    aws_subnet.SUBNETS
  ]
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = var.ALL-VPC-INFO.private-subnets ##PASSING THE VARIABLES OF PRIVATE-SUBNETS
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc-id]
  }
  depends_on = [
    aws_subnet.SUBNETS
  ]
}

resource "aws_route_table_association" "public" {
  count          = length(var.ALL-VPC-INFO.public-subnets)  ##USING THE LENGTH
  subnet_id      = data.aws_subnets.public.ids[count.index] ##QUERYING THE PUBLIC-SUBNETS FROM AWS-SUBNETS PUBLIC DATA RESOURCE
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.ALL-VPC-INFO.private-subnets)  ##USING THE LENGTH
  subnet_id      = data.aws_subnets.private.ids[count.index] ##QUERYING THE PRIVATE-SUBNETS FROM AWS-SUBNETS PRIVATE DATA RESOURCE
  route_table_id = aws_route_table.private.id
}