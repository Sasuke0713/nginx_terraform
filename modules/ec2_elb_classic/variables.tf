variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "webserver_min_size" {
  default = 1
}

variable "webserver_max_size" {
  default = 1
}

variable "webserver_desired_size" {
  default = 1
}

variable "webpage" {
  description = "Name of webpage we want running"
  type        = string
}

variable "service" {
  description = "Service we're running on EC2 Instance"
  type        = string
}

variable "aws_availability_zones" {
  description = "A list of availability zones to use for the VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}


