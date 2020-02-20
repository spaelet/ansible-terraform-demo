
# Provider ======================================================

provider "aws" {
  region = "us-east-1"
}

# EC2 AMI =======================================================

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's owner ID
}

# VPC ===========================================================

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  tags = {
    Name = "${var.stack_name}"
  }
}

# HTTP From World Security Group ================================

resource "aws_security_group" "http_from_world" {
  name        = "http_from_world"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.stack_name}-http-from-world"
  }
}

resource "aws_security_group_rule" "http_from_world" {
  type              = "ingress"
  security_group_id = "${aws_security_group.http_from_world.id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# SSH From World Security Group =================================

resource "aws_security_group" "ssh_from_world" {
  name        = "ssh_from_world"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.stack_name}-ssh-from-world"
  }
}

resource "aws_security_group_rule" "ssh_from_world" {
  type              = "ingress"
  security_group_id = "${aws_security_group.ssh_from_world.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Egress to World Security Group ================================

resource "aws_security_group" "egress_to_world" {
  name        = "egress_to_world"
  description = "Allows all traffic egress to world"
  vpc_id      = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.stack_name}-egress-to-world"
  }
}

resource "aws_security_group_rule" "egress_to_world" {
  type              = "egress"
  security_group_id = "${aws_security_group.egress_to_world.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# EC2 Key Pair ==================================================

resource "aws_key_pair" "master" {
  key_name   = "${var.stack_name}-master"
  public_key = "${file(pathexpand(var.public_key_path))}"
}

# Internet Gateway =================================================

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.stack_name}"
  }
}

# Public Subnet =================================================

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.stack_name}-public"
  }
}

# Public Subnet Route Table =====================================

resource "aws_route_table" "public" {
  vpc_id                 = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.stack_name}-public"
  }
}

resource "aws_route" "route" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id              = "${aws_subnet.public.id}"
  route_table_id         = "${aws_route_table.public.id}"
}

# EC2 instance ==================================================

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.ubuntu.image_id}"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.id}"
  key_name               = "${aws_key_pair.master.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh_from_world.id}",
    "${aws_security_group.http_from_world.id}",
    "${aws_security_group.egress_to_world.id}",
  ]
  tags = {
    Name = "${var.stack_name}-web"
  }
}

# Outputs =======================================================

output "ip" {
  value = "${aws_instance.web.public_ip}"
}
