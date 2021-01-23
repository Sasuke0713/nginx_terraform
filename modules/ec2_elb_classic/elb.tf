resource "aws_elb" "service_webserver_elb" {
  name               = "${terraform.workspace}-classic-${var.service}-elb"
  availability_zones = var.aws_availability_zones
  security_groups = [aws_security_group.service_elb_sg.id]

  internal = false

  listener {
    lb_port           = 80
    lb_protocol       = "tcp"
    instance_port     = 8080
    instance_protocol = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    target              = "TCP:8080"
    interval            = 15
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}