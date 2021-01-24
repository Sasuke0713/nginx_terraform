
resource "aws_security_group" "service_sg" {
  name        = "${terraform.workspace}-${var.service}-webserver-sg"
  description = "Security group for ${var.service} Webserver ec2 hosts."
  vpc_id      = var.vpc_id
  tags        = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "service_ingress_from_elb_tcp" {
  from_port                = 80
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.service_sg.id
  source_security_group_id = aws_security_group.service_elb_sg.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_ssh_from_my_ip" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["99.107.132.63/32"]
  security_group_id = aws_security_group.service_sg.id
}

resource "aws_security_group_rule" "allow_all_outbound_from_ec2" {
  security_group_id = aws_security_group.service_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic."
}

resource "aws_security_group" "service_elb_sg" {
  name        = "${terraform.workspace}-${var.service}-elb-sg"
  description = "Security group for ${var.service} elb."
  vpc_id      = var.vpc_id
  tags        = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elb_ingress_from_internet" {
  from_port                = 80
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.service_elb_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
  type                     = "ingress"
}

resource "aws_security_group_rule" "elb_egress_to_webserver" {
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.service_elb_sg.id
  source_security_group_id = aws_security_group.service_sg.id
  type                     = "egress"
}
