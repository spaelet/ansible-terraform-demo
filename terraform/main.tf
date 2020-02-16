provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-000b3a073fc20e415"
  instance_type = "t2.micro"
  subnet_id     = "subnet-019cc073bf436c0a7"
  key_name      = "dev-vpc-master"
  vpc_security_group_ids = [
    "sg-0ed6e83261b267af9",
    "sg-0fe8fe03dbe60a117",
    "sg-011901571756c0eb3"
  ]
  tags = {
    Name = "Demo Instance"
  }
}

output "ip" {
  value = "${aws_instance.demo.public_ip}"
}
