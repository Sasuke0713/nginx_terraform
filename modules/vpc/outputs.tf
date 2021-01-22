output "vpc_public_subnet_ids" {
  value = [
    "${aws_subnet.public_subnet_01.id}",
    "${aws_subnet.public_subnet_02.id}",
    "${aws_subnet.public_subnet_03.id}",
  ]
}

output "vpc_private_subnet_ids" {
  value = [
    "${aws_subnet.private_subnet_01.id}",
    "${aws_subnet.private_subnet_02.id}",
    "${aws_subnet.private_subnet_03.id}",
  ]
}

output "vpc_private_subnet_arns" {
  value = [
    "${aws_subnet.private_subnet_01.arn}",
    "${aws_subnet.private_subnet_02.arn}",
    "${aws_subnet.private_subnet_03.arn}",
  ]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "default_security_group_id" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

output "vpc_availability_zones" {
  value = [
    "${var.aws_availability_zones}",
  ]
}

output "private_subnet_01_route_table_id" {
  value = "${aws_route_table.vpc_private01_route.id}"
}

output "private_subnet_02_route_table_id" {
  value = "${aws_route_table.vpc_private02_route.id}"
}

output "private_subnet_03_route_table_id" {
  value = "${aws_route_table.vpc_private03_route.id}"
}
