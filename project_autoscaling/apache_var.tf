# Variables Apache VPC
variable "cidr-block" {
    type = string
    default = "10.72.0.0/16"  
}


variable "project-apache" {
    type = string
    default = "project_apache"
  
}


# Variables for Compute
variable "ami" {
    type = string
    default = "ami-04149c54d7c56180d"
  
}
