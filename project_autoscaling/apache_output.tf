# VPC 
output "aws_vpc" {
  value       = aws_vpc.main.id
  description = "Apache ASG vpc"
}


# Application Load Balancer
output "alb_dns_name" {
    value       = aws_lb.alb-apache.dns_name
  description = "ALB DNS name"
  
}

# Launch Template ARN
output "aws_launch_template" {
    value = aws_launch_template.apache-lt.arn
    description = "Launch Template ARN"
  
}