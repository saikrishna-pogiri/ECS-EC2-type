# Web Server Security Group

resource "aws_security_group" "webservers" {
 name = "${var.project_name}-webserver-sg"
 vpc_id = "${aws_vpc.terraform.id}"

  tags {
    Name = "${var.project_name}-webserver-sg"
    Environment = "${var.environment_name}"
  }

     ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
      from_port =80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     }

     egress {
     from_port = 0
     to_port = 0
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
     }
 }

 # Security Group for ELB

 resource "aws_security_group" "elb" {
 vpc_id = "${aws_vpc.terraform.id}"
  name = "${var.project_name}-elb"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port =0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
 }

 #  Security Group for Launch launch_configuration

 resource "aws_security_group" "ASG-LC" {
  name = "ASG-LC"
  description = "allow HTTP inbound connection"
  vpc_id = "${aws_vpc.terraform.id}"

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

     }

     egress {
       from_port    = 0
       to_port      = 0
       protocol     = "-1"
       cidr_blocks  = ["0.0.0.0/0"]
     }

    }


    resource "aws_security_group" "lb_sg" {
  description = "controls access to the application ELB"

  vpc_id = "${aws_vpc.terraform.id}"
  name   = "demo-ELB"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "instance_sg" {
  description = "controls direct access to application instances"
  vpc_id = "${aws_vpc.terraform.id}"
  name        = "application-instances-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 32768
    to_port     = 65535
    description = "Access from ALB"

    security_groups = [
      "${aws_security_group.lb_sg.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
