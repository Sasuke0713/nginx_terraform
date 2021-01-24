### ECS

data "local_file" "webpage_index" {
    filename = "${path.module}/files/index.html"
}

resource "aws_ecs_cluster" "service" {
  name = "${terraform.workspace}-${var.service}-service"
  tags = var.tags
}

resource "aws_ecs_task_definition" "service" {
  family                   = "${terraform.workspace}-${var.service}-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  volume {
    name      = "${terraform.workspace}-${var.service}-service-conf-vol"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.service.id
      root_directory = "/"
    }
  }

  container_definitions = <<DEFINITION
  [
    {
      "image": "nginx:stable",
      "name": "${terraform.workspace}-${var.service}-service",
      "essential": true,
      "memory": ${var.service_memory},
      "stopTimeout": 120,
      "DependsOn": [
        {
           "Condition": "COMPLETE",
           "ContainerName": "${terraform.workspace}-${var.service}-service-config"
        }
      ],
      "logConfiguration": { 
        "logDriver": "awslogs",
        "options": { 
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/service/fargate/${terraform.workspace}-${var.service}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${terraform.workspace}-${var.service}"
        }
      },
      "portMappings": [
        {
          "ContainerPort": ${var.service_port},
          "HostPort": ${var.service_port},
          "Protocol": "tcp"
        }
      ],
      "MountPoints": [
        {
          "ContainerPath": "/usr/share/nginx/html",
          "SourceVolume": "${terraform.workspace}-${var.service}-service-conf-vol"
        }
      ]
    },
    {
      "image": "bash",
      "name": "${terraform.workspace}-${var.service}-service-config",
      "essential": false,
      "Command": [
        "-c",
        "echo $WEBPAGE | base64 -d - | tee /usr/share/nginx/html/index.html"
      ],
      "Environment": [
        {
          "Name": "WEBPAGE",
          "Value": "${data.local_file.webpage_index.content_base64}"
        }
      ],
      "MountPoints": [
        {
          "ContainerPath": "/usr/share/nginx/html",
          "SourceVolume": "${terraform.workspace}-${var.service}-service-conf-vol"
        }
      ]
    }
  ]
  
DEFINITION

}

resource "aws_ecs_service" "service" {
  name            = "${terraform.workspace}-${var.service}-service"
  cluster         = aws_ecs_cluster.service.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.service_count
  launch_type     = "FARGATE"
  platform_version = "1.4.0" //Until they update LATEST to the newest platform version

  network_configuration {
    security_groups = [aws_security_group.service_container_sg.id]
    subnets         = var.vpc_private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service_blue_tg.id
    container_name   = "${terraform.workspace}-${var.service}-service"
    container_port   = var.service_port
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${terraform.workspace}-${var.service}-service"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/service/fargate/${terraform.workspace}-${var.service}"
  retention_in_days = "7"
  tags              = var.tags
}
