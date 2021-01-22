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
  name_prefix          = "${var.service}_webserver"
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
  availability_zones        = var.aws_availability_zones
  load_balancers            = [aws_elb.service_webserver_elb.name]
  min_size                  = var.webserver_min_size
  max_size                  = var.webserver_max_size
  wait_for_elb_capacity     = var.webserver_min_size
  desired_capacity          = var.webserver_desired_size
  health_check_grace_period = 180
  health_check_type         = "ELB"
  name                      = "${var.service}_webserver_asg_${aws_launch_configuration.service_webserver.name}"

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
