resource "aws_security_group" "service_container_sg" {
  name        = "${terraform.workspace}-${var.service}_service-container_sg"
  description = "Security group for the service-${terraform.workspace} containers."
  vpc_id      = var.vpc_id
  tags        = var.tags

  ingress {
    protocol        = "tcp"
    from_port       = var.service_port
    to_port         = var.service_port
    security_groups = [aws_security_group.service_alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "service_alb" {
  name        = "${terraform.workspace}-${var.service}_service_alb_sg"
  description = "Security group for the service-${terraform.workspace} alb."
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_inbound_tcp80_traffic_service-alb" {
  security_group_id = aws_security_group.service_alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["99.107.132.63/32"]
  description       = "Allow inbound traffic on tcp port"
}

resource "aws_security_group_rule" "allow_inbound_tcp443_traffic_service-alb" {
  security_group_id = aws_security_group.service_alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["99.107.132.63/32"]
  description       = "Allow inbound traffic on tcp port"
}

resource "aws_security_group_rule" "allow_all_outbound_from_elb_to_containers" {
  security_group_id = aws_security_group.service_alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic."
}

resource "aws_security_group" "sg_efs_filesystem" {
  name        = "${terraform.workspace}-${var.service}-efs-filesystem-service"
  description = "Allows only necessary ingress traffic to efs-filesystem-service"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "allow_inbound_efs_filesystem_from_myIP" {
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_efs_filesystem.id
  cidr_blocks       = ["99.107.132.63/32"]
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_from_service_efs_filesystem" {
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_efs_filesystem.id
  source_security_group_id = aws_security_group.service_container_sg.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "outbound_from_service_efs_filesystem" {
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_efs_filesystem.id
  source_security_group_id = aws_security_group.service_container_sg.id
  type                     = "egress"
}
