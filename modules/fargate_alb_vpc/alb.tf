#### ALB ####

resource "aws_alb" "service_alb" {
  name            = "${terraform.workspace}-${var.service}-service-alb"
  internal        = false
  security_groups = [ aws_security_group.service_alb.id ]
  subnets         = var.vpc_public_subnet_ids
  tags            = var.tags
}

resource "aws_alb_target_group" "service_blue_tg" {
  port                 = var.service_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = "120"
  health_check {
    port                = var.service_port
    healthy_threshold   = 5
    interval            = 15
    unhealthy_threshold = 3
    timeout             = 10
    path                = "/"
    matcher             = "200-301"
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_alb_listener" "service_http" {
  load_balancer_arn = aws_alb.service_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.service_blue_tg.arn
    type             = "forward"
  }
}
