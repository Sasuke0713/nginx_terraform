resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name        = var.vpc_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_01_cidr_block
  availability_zone       = var.aws_availability_zones[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = var.public_subnet_01_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_subnet" "public_subnet_02" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_02_cidr_block
  availability_zone       = var.aws_availability_zones[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = var.public_subnet_02_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_subnet" "public_subnet_03" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_03_cidr_block
  availability_zone       = var.aws_availability_zones[2]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = var.public_subnet_03_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_subnet" "private_subnet_01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_01_cidr_block
  availability_zone = var.aws_availability_zones[0]

  tags = {
    Name        = var.private_subnet_01_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_02_cidr_block
  availability_zone = var.aws_availability_zones[1]

  tags = {
    Name        = var.private_subnet_02_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_subnet" "private_subnet_03" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_03_cidr_block
  availability_zone = var.aws_availability_zones[2]

  tags = {
    Name        = var.private_subnet_03_name
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_eip" "public_subnet_01_nat_ip" {}

resource "aws_eip" "public_subnet_02_nat_ip" {}

resource "aws_eip" "public_subnet_03_nat_ip" {}

resource "aws_nat_gateway" "private_subnet_01_ngw" {
  allocation_id = aws_eip.public_subnet_01_nat_ip.id
  subnet_id     = aws_subnet.public_subnet_01.id

  tags = {
    Name        = "${var.private_subnet_01_name}-ngw"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_nat_gateway" "private_subnet_02_ngw" {
  allocation_id = aws_eip.public_subnet_02_nat_ip.id
  subnet_id     = aws_subnet.public_subnet_02.id

  tags = {
    Name        = "${var.private_subnet_02_name}-ngw"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_nat_gateway" "private_subnet_03_ngw" {
  allocation_id = aws_eip.public_subnet_03_nat_ip.id
  subnet_id     = aws_subnet.public_subnet_03.id

  tags = {
    Name        = "${var.private_subnet_03_name}-ngw"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_route_table" "vpc_public_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-public-route"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_route" "vpc_public_route_default" {
  route_table_id = aws_route_table.vpc_public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "vpc_public_route01" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.vpc_public_route.id
}

resource "aws_route_table_association" "vpc_public_route02" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = aws_route_table.vpc_public_route.id
}

resource "aws_route_table_association" "vpc_public_route03" {
  subnet_id      = aws_subnet.public_subnet_03.id
  route_table_id = aws_route_table.vpc_public_route.id
}

resource "aws_route_table" "vpc_private01_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.private_subnet_01_name}-route"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_route" "vpc_private01_route_default" {
  route_table_id = aws_route_table.vpc_private01_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_subnet_01_ngw.id
}

resource "aws_route_table" "vpc_private02_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.private_subnet_02_name}-route"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_route" "vpc_private02_route_default" {
  route_table_id = aws_route_table.vpc_private02_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_subnet_02_ngw.id
}

resource "aws_route_table" "vpc_private03_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.private_subnet_03_name}-route"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_route" "vpc_private03_route_default" {
  route_table_id = aws_route_table.vpc_private03_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_subnet_03_ngw.id
}

resource "aws_route_table_association" "vpc_private01_route" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.vpc_private01_route.id
}

resource "aws_route_table_association" "vpc_private02_route" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.vpc_private02_route.id
}

resource "aws_route_table_association" "vpc_private03_route" {
  subnet_id      = aws_subnet.private_subnet_03.id
  route_table_id = aws_route_table.vpc_private03_route.id
}

resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = {
    Name        = "${var.vpc_name}-s3-endpoint"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_vpc_endpoint" "dynamodb_vpc_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"

  tags = {
    Name        = "${var.vpc_name}-dynamodb-endpoint"
    Billing     = var.billing_tag
    ProductName = var.product_name_tag
    Security    = var.security_tag
    Environment = var.environment_tag
    Department  = var.department_tag
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpc_endpoint_association_public" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_public_route.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpc_endpoint_association_private_01" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_private01_route.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpc_endpoint_association_private_02" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_private02_route.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpc_endpoint_association_private_03" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_private03_route.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_vpc_endpoint_association_public" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_public_route.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamoddb_vpc_endpoint_association_private_01" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_private01_route.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_vpc_endpoint_association_private_02" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_private02_route.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_vpc_endpoint_association_private_03" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_vpc_endpoint.id
  route_table_id  = aws_route_table.vpc_private03_route.id
}
