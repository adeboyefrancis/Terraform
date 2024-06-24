# Create WordPress Bastion & WordPress (Compute)
resource "aws_instance" "bastion-host" {
    ami = "${var.ami}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    subnet_id = aws_subnet.public_subnet_1.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.bastion-host-sg.id]
   tags = {
     Name = "${var.project-wordpress}-bastion-host"
   } 
    
}

data "template_file" "user_data" {
  template = file("user_data.tpl")

  vars = {

    db_name     = "${var.db_name}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
    db_host     = "${aws_db_instance.wordpress-rds.endpoint}"
    
  }

}

resource "aws_iam_role" "wordpress_role" {
  name               = "wordpress-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.wordpress_role.name
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_instance" "wordpress-server" {
    ami = "${var.ami}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    subnet_id = aws_subnet.private_subnet_2.id
    security_groups = [aws_security_group.wordpress-sg.id]
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name
    user_data = data.template_file.user_data.rendered
 

   tags = {
     Name = "${var.project-wordpress}-wordpress-server"
   } 
  
  depends_on = [aws_db_instance.wordpress-rds,aws_lb.wordpress-alb] # Due to rds endpoint late provisioning and to avoid ALB health check 
  
}

