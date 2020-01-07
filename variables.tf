# Project Wide Variable

variable "project_name" {
 default = "terraform"
}

variable "environment_name" {
 default = "dev"
}

# VPC Variables

variable "vpc-cidr-block" {
	default = "10.0.0.0/16"
}
variable "pub-sub1-cidr_block" {
	default = "10.0.1.0/24"
}
variable "pub-sub2-cidr_block" {
	default = "10.0.2.0/24"
}
variable "pri-sub1-cidr_block" {
	default = "10.0.3.0/24"
}
variable "pri-sub2-cidr_block" {
	default = "10.0.4.0/24"
}


# EC2 instance Variables

variable "count" {
 default = "2"
}

variable "ami_type" {
 default = "ami-0c5204531f799e0c6"
}
 variable "instance_type" {
  default = "t2.micro"
 }

 variable "key_name" {
  default = "Oregon-KI"
 }
