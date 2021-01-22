data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/user_data.tpl")

  vars = {
    webpage = var.webpage
    title_webpage = "Cisco SPL"
  }
}

resource "aws_launch_configuration" "service_webserver" {
  name_prefix          = "${terraform.workspace}_${var.service}_webserver"
  image_id             = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.service_sg.id]
  user_data            = data.template_file.userdata.rendered

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = "10"
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  launch_configuration      = aws_launch_configuration.service_webserver.id
  vpc_zone_identifier       = var.vpc_private_subnet_ids
  load_balancers            = [aws_elb.service_webserver_elb.name]
  min_size                  = var.webserver_min_size
  max_size                  = var.webserver_max_size
  wait_for_elb_capacity     = var.webserver_min_size
  desired_capacity          = var.webserver_desired_size
  health_check_grace_period = 180
  health_check_type         = "ELB"
  name                      = "${terraform.workspace}_${var.service}_webserver_asg_${aws_launch_configuration.service_webserver.name}"

  lifecycle {
    create_before_destroy = true
  }

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = aws_launch_configuration.service_webserver.name
        "propagate_at_launch" = true
      },
    ] 
  )
}

resource "aws_autoscaling_policy" "webserver_scale_up" {
    name = "${terraform.workspace}-${var.service}-webserver-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}

resource "aws_autoscaling_policy" "webserver_scale_down" {
    name = "${terraform.workspace}-${var.service}-webserver-scale-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu-high" {
    alarm_name = "mem-util-high-${terraform.workspace}-${var.service}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "3"
    metric_name = "CPUUtilization"
    namespace = "System/Linux"
    period = "60"
    statistic = "Average"
    threshold = "75"
    alarm_description = "This metric monitors ec2 cpu for high utilization on agent hosts"
    alarm_actions = [
        aws_autoscaling_policy.webserver_scale_up.arn
    ]
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
    }
}

resource "aws_cloudwatch_metric_alarm" "cpu-low" {
    alarm_name = "mem-util-low-${terraform.workspace}-${var.service}"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "3"
    metric_name = "CPUUtilization"
    namespace = "System/Linux"
    period = "300"
    statistic = "Average"
    threshold = "40"
    alarm_description = "This metric monitors ec2 cpu for low utilization on agent hosts"
    alarm_actions = [
        aws_autoscaling_policy.webserver_scale_down.arn
    ]
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
    }
}
