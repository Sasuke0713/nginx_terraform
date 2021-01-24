variable "tags" {
  default = {
    ProductName = "Nginx"
  }
}

variable "service_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "80"
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
  default = "172.13.0.0/16"
}

variable "public_subnet_01_cidr_block" {
  default = "172.13.64.0/22"
}

variable "public_subnet_02_cidr_block" {
  default = "172.13.68.0/22"
}

variable "public_subnet_03_cidr_block" {
  default = "172.13.72.0/22"
}

variable "private_subnet_01_cidr_block" {
  default = "172.13.76.0/22"
}

variable "private_subnet_02_cidr_block" {
  default = "172.13.80.0/22"
}

variable "private_subnet_03_cidr_block" {
  default = "172.13.84.0/22"
}
