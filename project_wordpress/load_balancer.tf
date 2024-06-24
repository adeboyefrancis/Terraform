# Create WordPress ALB & Dependencies (Compute)
resource "aws_lb" "wordpress-alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]
  ip_address_type    = "ipv4"
  
  tags = {
    Environment = "${var.project-wordpress}-wordpress-alb"
  }
}

resource "aws_lb_target_group" "wordpress-tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path = "/"
    port = 80
    protocol = "HTTP"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200,302"
  }
}

resource "aws_lb_listener" "wordpress-listener" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }

  tags = {
    Environment = "${var.project-wordpress}-alb-listener"
  }
}

resource "aws_lb_target_group_attachment" "wordpess-server" {
  target_group_arn = aws_lb_target_group.wordpress-tg.arn
  target_id        = aws_instance.wordpress-server.id
  port             = 80
}