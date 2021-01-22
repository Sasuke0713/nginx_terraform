variable "tags" {
  type    = map(string)
  default = {}
}

variable "aws_region" {
  description = "The AWS region to build the VPC in"
}

variable "aws_profile" {
  description = "The AWS credentials profile to use"
  default     = "AWS Profile to build architecture in"
}

variable "aws_availability_zones" {
  description = "A list of availability zones to use for the VPC"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block to use for the VPC"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "public_subnet_01_name" {
  description = "The name to use for public subnet 01"
}

variable "public_subnet_02_name" {
  description = "The name to use for public subnet 02"
}

variable "public_subnet_03_name" {
  description = "The name to use for public subnet 03"
}

variable "public_subnet_01_cidr_block" {
  description = "The CIDR block to use for public subnet 01"
}

variable "public_subnet_02_cidr_block" {
  description = "The CIDR block to use for public subnet 02"
}

variable "public_subnet_03_cidr_block" {
  description = "The CIDR block to use for public subnet 03"
}

variable "private_subnet_01_name" {
  description = "The name to use for private subnet 01"
}

variable "private_subnet_02_name" {
  description = "The name to use for private subnet 02"
}

variable "private_subnet_03_name" {
  description = "The name to use for private subnet 03"
}

variable "private_subnet_01_cidr_block" {
  description = "The CIDR block to use for private subnet 01"
}

variable "private_subnet_02_cidr_block" {
  description = "The CIDR block to use for private subnet 02"
}

variable "private_subnet_03_cidr_block" {
  description = "The CIDR block to use for private subnet 03"
}
