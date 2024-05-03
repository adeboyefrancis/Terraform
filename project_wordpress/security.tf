# # Create WordPress Security Groups (Security)
# #RDS SG
# resource "aws_security_group" "rds-sg" {
#     name = "rds-sg"
#     description = "Allow Traffic from WordPress Instance"
#     vpc_id = aws_vpc.main.id
    
#     ingress {
#         from_port = 3306
#         to_port = 3306
#         protocol = "tcp"
#         security_groups = [aws_security_group.wordpress-sg.id]
#     }

#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#    }
#    tags = {
#      Name = "${var.project-wordpress}-rds-sg"
#    }
# }

# # wordPress Instance SG
# resource "aws_security_group" "wordpress-sg" {
#     name = "wordPress-sg"
#     description = "Allow Traffic ALB on port 80 & Bastion Host on Port 22"
#     vpc_id = aws_vpc.main.id
    
# ingress {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         security_groups = [aws_security_group.alb-sg.id]
#     }


# ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         security_groups = [aws_security_group.bastion-host-sg.id]
#     }

# egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#    }
#    tags = {
#      Name = "${var.project-wordpress}-wordpress-sg"
#    }
# }

# # Bastion Host SG
# resource "aws_security_group" "bastion-host-sg" {
#     name = "bastion-host-sg"
#     description = "Allow SSH access from my IP on port 22"
#     vpc_id = aws_vpc.main.id
    
# ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         cidr_blocks = ["209.35.85.27/32"]
#     }

# egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#    }

#     tags = {
#      Name = "${var.project-wordpress}-bastion-host-sg"
#    }
# }

# # ALB SG
# resource "aws_security_group" "alb-sg" {
#     name = "alb-sg"
#     description = "Allow traffic from Internet HTTP"
#     vpc_id = aws_vpc.main.id
    
# ingress {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

# egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#    }

#     tags = {
#      Name = "${var.project-wordpress}-alb-sg"
#    }
# }