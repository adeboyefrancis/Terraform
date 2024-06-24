# VPC 
output "aws-vpc-name" {
  value       = aws_vpc.main.id
  description = "My WordPress VPC using Terraform"
}

# RDS
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.wordpress-rds.endpoint
  
}

# Bastion 
output "bastion_public_dns" {
  description = "Bastion Host Public DNS"
  value = aws_instance.bastion-host.public_dns
}

output "bastion_public_ip" {
    description = "Bastion Public IP"
  value = aws_instance.bastion-host.public_ip
}

# Application Load Balancer
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.wordpress-alb.dns_name
  
}
