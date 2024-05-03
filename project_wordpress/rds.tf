# # Create WordPress RDS (Database)
# resource "aws_db_subnet_group" "db_subnet" {
#   name       = "db_subnet"
#   subnet_ids = [aws_subnet.private_subnet_1.id,aws_subnet.private_subnet_2.id]

#   tags = {
#     Name = "${var.project-wordpress}-db-subnet-group"
#   }
# }


# resource "aws_db_instance" "wordpress-rds" {
#   identifier = "my-wordpress-rds"
#   allocated_storage    = 20
#   db_name              = "${var.db_name}"
#   username             = "${var.db_username}"
#   password             = "${var.db_password}"
#   engine               = "mariadb"
#   engine_version       = "10.5"
#   instance_class       = "db.t3.micro"
#   storage_type         = "gp2"
#   skip_final_snapshot  = true
#   multi_az = false
#   storage_encrypted = true
#   db_subnet_group_name = aws_db_subnet_group.db_subnet.name
#   publicly_accessible = false
#   port = "3306"
#   vpc_security_group_ids = [aws_security_group.rds-sg.id,aws_security_group.wordpress-sg.id]
 
#   tags = {
#     Name = "${var.project-wordpress}-wordpress-rds"
#   }
# }
