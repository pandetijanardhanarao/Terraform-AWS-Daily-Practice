variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.0.0/28"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.0.16/28"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}