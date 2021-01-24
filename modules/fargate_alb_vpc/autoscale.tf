resource "aws_appautoscaling_target" "service_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.service.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "${terraform.workspace}-${var.service}-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.service.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.service_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  alarm_name          = "${terraform.workspace}-${var.service}-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.service.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.service_down.arn]
}

resource "aws_appautoscaling_policy" "service_up" {
  name               = "${terraform.workspace}-${var.service}-scale-up"
  service_namespace  = aws_appautoscaling_target.service_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.service_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "service_down" {
  name               = "${terraform.workspace}-${var.service}-scale-down"
  service_namespace  = aws_appautoscaling_target.service_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.service_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  alarm_name          = "${terraform.workspace}-${var.service}-Memory-Utilization-High-${var.ecs_as_memory_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_memory_high_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.service.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.service_up_memory.arn]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_low" {
  alarm_name          = "${terraform.workspace}-${var.service}-Memory-Utilization-Low-${var.ecs_as_memory_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_memory_low_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.service.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.service_down_memory.arn]
}

resource "aws_appautoscaling_policy" "service_up_memory" {
  name               = "${terraform.workspace}-${var.service}-scale-up-memory"
  service_namespace  = aws_appautoscaling_target.service_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.service_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "service_down_memory" {
  name               = "${terraform.workspace}-${var.service}-scale-down-memory"
  service_namespace  = aws_appautoscaling_target.service_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.service_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "service-scale-up-requests-per-target" {
  name               = "${terraform.workspace}-${var.service}-scale-up-requests-per-target"
  service_namespace  = aws_appautoscaling_target.service_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.service_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_alb.service_alb.arn_suffix}/${aws_alb_target_group.service_blue_tg.arn_suffix}"
    }
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
    target_value = 1000.0
  }
}
