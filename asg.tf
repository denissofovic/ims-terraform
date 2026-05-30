resource "aws_autoscaling_group" "frontend" {
  name                = "frontend-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 4
  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.frontend.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 900
  default_cooldown = 500

  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name                = "backend-asg"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4
  vpc_zone_identifier = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.backend.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 900
  default_cooldown = 500


  tag {
    key                 = "Name"
    value               = "backend-instance"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "frontend_cpu_policy" {
  name                   = "frontend-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"

  estimated_instance_warmup = 600

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80
  }
}


resource "aws_autoscaling_policy" "backend_cpu_policy" {
  name                   = "backend-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type            = "TargetTrackingScaling"

  estimated_instance_warmup = 600


  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}