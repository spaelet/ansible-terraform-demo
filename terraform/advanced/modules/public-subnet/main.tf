

resource "aws_internet_gateway" "igw" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.stack_name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.cidr_block}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.stack_name}-public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
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
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

output "id" {
  value = "${aws_subnet.public.id}"
}

