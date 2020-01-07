data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Creation
resource "aws_vpc" "terraform" {
 cidr_block = "${var.vpc-cidr-block}"
 enable_dns_support = "true"
 enable_dns_hostnames = "true"

  tags {
    Name = "${var.project_name}- vpc"
    Environment = "${var.environment_name}"
  }
}

# Subnets

# Public Subnet1

resource "aws_subnet" "pub_subnet1" {
vpc_id = "${aws_vpc.terraform.id}"
cidr_block = "${var.pub-sub1-cidr_block}"
availability_zone = "${data.aws_availability_zones.available.names[0]}"
map_public_ip_on_launch= "true"

 tags {
    Name = "${var.project_name}-pub-subnet1"
    Environment = "${var.environment_name}"
 }
}

# Public Subnet2

resource "aws_subnet" "pub_subnet2" {
vpc_id = "${aws_vpc.terraform.id}"
cidr_block = "${var.pub-sub2-cidr_block}"
availability_zone = "${data.aws_availability_zones.available.names[1]}"
map_public_ip_on_launch ="true"

  tags{
   Name = "${var.project_name}_pub_subnet2"
   Environment = "${var.environment_name}"
   }
  }


  # Private Subnet1

 resource "aws_subnet" "pri_subnet1" {
 vpc_id = "${aws_vpc.terraform.id}"
 cidr_block = "${var.pri-sub1-cidr_block}"
 availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags{
     Name = "${var.project_name}-pri-subnet1"
     Environment = "${var.environment_name}"
  }
 }


 # Private Subnet2

 resource "aws_subnet" "pri_subnet2" {
 vpc_id = "${aws_vpc.terraform.id}"
 cidr_block = "${var.pri-sub2-cidr_block}"
 availability_zone = "${data.aws_availability_zones.available.names[0]}"

   tags {
    Name = "${var.project_name}-pri-subnet2"
    Environment = "${var.environment_name}"
   }
 }

 # Internet Gateway

 resource "aws_internet_gateway" "terraform-igw" {
 vpc_id = "${aws_vpc.terraform.id}"

   tags {
    Name = "${var.project_name}_IGW"
    Environment = "${var.environment_name}"
   }
 }

 # Elastic IP for NAT Gateway
 resource "aws_eip" "terraform-nat-eip" {
   vpc = "true"
   depends_on = ["aws_internet_gateway.terraform-igw"]
 }

 # NAT Gateway for private Subnets

 resource "aws_nat_gateway" "terraform_nat" {
   subnet_id = "${aws_subnet.pub_subnet1.id}"
   allocation_id = "${aws_eip.terraform-nat-eip.id}"
   depends_on = ["aws_internet_gateway.terraform-igw"]
   tags {
    Name = "${var.project_name}_NAT"
    Environment = "${var.environment_name}"
   }
 }

 # Route Table for Public Subnets

 resource "aws_route_table" "pub_routetable"{
 vpc_id = "${aws_vpc.terraform.id}"
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = "${aws_internet_gateway.terraform-igw.id}"
  }
     tags {
       Name = "${var.project_name}-pub-rt"
       Environment = "${var.environment_name}"
      }
 }

 # Route Table for Private Subnets

  resource "aws_route_table" "pri_routetable" {
  vpc_id = "${aws_vpc.terraform.id}"
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.terraform_nat.id}"
   }
   tags {
     Name = "${var.project_name}-pri-rt"
     Environment = "${var.environment_name}"
    }
  }
# Route table Association with Public Subnets

resource "aws_route_table_association" "to-pub-subnet1" {
 subnet_id = "${aws_subnet.pub_subnet1.id}"
 route_table_id = "${aws_route_table.pub_routetable.id}"
}

resource "aws_route_table_association" "to-pub_sunnet2" {
subnet_id = "${aws_subnet.pub_subnet2.id}"
route_table_id = "${aws_route_table.pub_routetable.id}"
}

# Route table association with private subnets
resource "aws_route_table_association" "to-pri-subnet1" {
    subnet_id = "${aws_subnet.pri_subnet1.id}"
    route_table_id = "${aws_route_table.pri_routetable.id}"
}

resource "aws_route_table_association" "to-pri-subnet2" {
    subnet_id = "${aws_subnet.pri_subnet2.id}"
    route_table_id = "${aws_route_table.pri_routetable.id}"
}
