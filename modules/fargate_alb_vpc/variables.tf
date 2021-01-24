variable "tags" {
  type    = map(string)
  default = {}
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

variable "vpc_public_subnet_ids" {
  description = "A list of public subnet ids"
  type        = list(string)
}

variable "vpc_private_subnet_ids" {
  description = "A list of private subnet ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "aws_region" {
  description = "Number of docker containers to run"
  default     = "us-west-2"
}

variable "service_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "service_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "service_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 1024
}

variable "service_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  type        = string
}

variable "ecs_autoscale_min_instances" {
  default = "1"
  type    = string
}

variable "ecs_autoscale_max_instances" {
  default = "5"
  type    = string
}

variable "ecs_as_cpu_low_threshold_per" {
  default = "40"
  type    = string
}

variable "ecs_as_cpu_high_threshold_per" {
  default = "70"
  type    = string
}

variable "ecs_as_memory_high_threshold_per" {
  default = "85"
  type    = string
}

variable "ecs_as_memory_low_threshold_per" {
  default = "60"
  type    = string
}

variable "ecs_as_request_per_target_connection_high_threshold_per" {
  default = "1000"
  type    = string
}
