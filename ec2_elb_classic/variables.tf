variable "tags" {
  default = {
    Environment = "Prototype"
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
