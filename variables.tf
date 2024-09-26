variable "aws_region" {
  default = "eu-wast-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default = "ami-0e309a5f3a6dd97ea"
}

variable "instance_type" {
  default = "t2.micro"
}
