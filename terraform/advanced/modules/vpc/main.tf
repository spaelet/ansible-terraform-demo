
# VPC =======================================================

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  tags = {
    Name = "${var.stack_name}"
  }
}

# Master Key ================================================

resource "aws_key_pair" "master" {
  key_name   = "${var.stack_name}-master"
  public_key = "${file(pathexpand(var.public_key_path))}"
}

# HTTP From World Group =====================================

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

# SSH From World Group =====================================

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

# Egress to World Group ==================================

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

# Outputs ==================================

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "http_from_world_group_id" {
  value = "${aws_security_group.http_from_world.id}"
}

output "ssh_from_world_group_id" {
  value = "${aws_security_group.ssh_from_world.id}"
}

output "egress_to_world_group_id" {
  value = "${aws_security_group.egress_to_world.id}"
}

output "key_name" {
  value = "${aws_key_pair.master.key_name}"
}

