# ALB Security Group
resource "aws_security_group" "alb-apache-sg" {
    description = "Allow HTTP traffic from Internet"
    vpc_id = aws_vpc.main.id
  

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] 
    
   
  }

   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"] 
  }

   tags = {
    name = "${var.project-apache}-alb-sg-apache"
  }
}

# ALB Apache , Target Group , Health Check, Listener, Target Group attachment
resource "aws_lb" "alb-apache" {
  name               = "apache-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-apache-sg.id]
  subnets            = [aws_subnet.public_subnet1_apache.id,aws_subnet.public_subnet2_apache.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "${var.project-apache}-alb-apache"
  }
}

resource "aws_lb_target_group" "alb-tg-apache" {
  name     = "alb-target-instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled = true
    path = "/"
    protocol = "HTTP"
    port = 80
    matcher = 200
  }
   tags = {
    name = "${var.project-apache}-alb-tg"
  }
}

resource "aws_alb_listener" "alb-lst-apache" {
  load_balancer_arn = aws_lb.alb-apache.arn
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-apache.arn
  }
}