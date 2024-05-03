#Apache

resource "aws_autoscaling_group" "asg-apache" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.private_subnet1_apache.id,aws_subnet.private_subnet2_apache.id]
  health_check_type = "ELB"
  termination_policies = ["OldestInstance"]
  target_group_arns = [aws_lb_target_group.alb-tg-apache.arn]
  
  
  launch_template {
    id      = aws_launch_template.apache-lt.id
    version = "$Latest"
    
  }
}

# Scaling Out Policiy

resource "aws_autoscaling_policy" "asg-apache-out" {
  name                   = "Scale-OUT-Policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg-apache.name
}

resource "aws_cloudwatch_metric_alarm" "asg-scale-out-alarm" {
  alarm_name          = "scale-out-asg"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-apache.name
  }

  alarm_description = "This metric monitors Increase of cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg-apache-out.arn]
}

# Scaling IN Policiy

resource "aws_autoscaling_policy" "asg-apache-in" {
  name                   = "Scale-in-Policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg-apache.name
}


resource "aws_cloudwatch_metric_alarm" "asg-scale-in-alarm" {
  alarm_name          = "scale-down-asg"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-apache.name
  }

  alarm_description = "This metric monitors Decrease of ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg-apache-in.arn]
}