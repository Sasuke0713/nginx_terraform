variable "tags" {
  default = {
    ProductName = "Nginx"
  }
}

variable "webserver_max_size" {
  default = 3
}

variable "webserver_desired_size" {
  default = 1
}

variable "webpage" {
  description = "Name of webpage we want running"
  default     = "cisco_spl"
}

variable "service" {
  description = "Service we're running on EC2 Instance"
  default     = "nginx"
}

variable "vpc_name" {
  default = "nginx-service"
}

variable "public_subnet_01_name" {
  default = "nginx-service-public01"
}

variable "public_subnet_02_name" {
  default = "nginx-service-public02"
}

variable "public_subnet_03_name" {
  default = "nginx-service-public03"
}

variable "private_subnet_01_name" {
  default = "nginx-service-private01"
}

variable "private_subnet_02_name" {
  default = "nginx-service-private02"
}

variable "private_subnet_03_name" {
  default = "nginx-service-private03"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "aws_availability_zones" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_cidr" {
  default = "172.18.0.0/16"
}

variable "public_subnet_01_cidr_block" {
  default = "172.18.64.0/22"
}

variable "public_subnet_02_cidr_block" {
  default = "172.18.68.0/22"
}

variable "public_subnet_03_cidr_block" {
  default = "172.18.72.0/22"
}

variable "private_subnet_01_cidr_block" {
  default = "172.18.76.0/22"
}

variable "private_subnet_02_cidr_block" {
  default = "172.18.80.0/22"
}

variable "private_subnet_03_cidr_block" {
  default = "172.18.84.0/22"
}
