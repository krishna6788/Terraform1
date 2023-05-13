variable = "us-east-1"
ALL-VPC-INFO = {
  availability-zones = ["a", "b", "c", "d", "e", "f"]                 ##GIVING VALUES OF AVAILABILITY ZONES FOR SUBNETS
  subnet-names       = ["APP1", "APP2", "WEB1", "WEB2", "DB1", "DB2"] ## NAMES OF THE SUBNETS FOR VPC
  vpc-cidr           = "192.168.0.0/16"                               ## CIDR RANGE FOR THE VPC
  public-subnets     = ["APP1", "APP2"]                               ## NAMES OF PUBLIC-SUBNETS
  private-subnets    = ["WEB1", "WEB2", "DB1", "DB2"]                 ## NAMES OF PRIVATE-SUBNETS
  db-subnets         = ["DB1", "DB2"]                                 ## NAMES OF DB SUBNETS
  web-ec2-subnet     = "APP1"
  ld-subnets         = ["APP1", "APP2", "WEB1", "WEB2"]
}