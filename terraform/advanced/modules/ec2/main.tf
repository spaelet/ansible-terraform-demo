
# AMI Lookup ==================================================

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

  owners = ["099720109477"] # Canonical
}

# EC2 instance ==================================================

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.ubuntu.image_id}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = "${var.security_group_ids}"
  tags = {
    Name = "${var.name}"
  }
}

# Outputs =======================================================

output "ip" {
  value = "${aws_instance.web.public_ip}"
}
