variable "region" {
  type        = string
  default     = "us-east-1"
  description = "CREATION OF REGION"

}

variable "ALL-VPC-INFO" {
  type = object({
    vpc-cidr           = string,
    subnet-names       = list(string),
    availability-zones = list(string),
    public-subnets     = list(string),
    private-subnets    = list(string),
    db-subnets         = list(string),
    web-ec2-subnet     = string,
    ld-subnets         = list(string)
  })
  default = {
    availability-zones = ["a", "b", "c", "d", "e", "f"]                 ##GIVING VALUES OF AVAILABILITY ZONES FOR SUBNETS
    subnet-names       = ["APP1", "APP2", "WEB1", "WEB2", "DB1", "DB2"] ## NAMES OF THE SUBNETS FOR VPC
    vpc-cidr           = "192.168.0.0/16"                               ## CIDR RANGE FOR THE VPC
    public-subnets     = ["APP1", "APP2"]                               ## NAMES OF PUBLIC-SUBNETS
    private-subnets    = ["WEB1", "WEB2", "DB1", "DB2"]                 ## NAMES OF PRIVATE-SUBNETS
    db-subnets         = ["DB1", "DB2"]                                 ## NAMES OF DB SUBNETS
    web-ec2-subnet     = "APP1"
    ld-subnets         = ["APP1", "APP2", "WEB1", "WEB2"]

  }

}