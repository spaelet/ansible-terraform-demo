
# Terraform Provider ============================================

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Terraform Backend =============================================

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "spaelet-tfstate"
    dynamodb_table = "spaelet-tfstate"
    region         = "us-east-1"
    key            = "terraform.tfstate"
  }
}

# VPC ===========================================================

module "vpc" {
  source               = "../modules/vpc"
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  stack_name           = "${var.stack_name}"
  public_key_path      = "${var.public_key_path}"
}

# Public Subnet =================================================

module "public_subnet" {
  source            = "../modules/public-subnet"
  vpc_id            = "${module.vpc.vpc_id}"
  availability_zone = "${var.availability_zone}"
  stack_name        = "${var.stack_name}"
  cidr_block        = "${var.public_subnet_cidr}"
}

# Web Server ====================================================

module "web" {
  source             = "../modules/ec2"
  subnet_id          = "${module.public_subnet.id}"
  key_name           = "${module.vpc.key_name}"
  security_group_ids = "${list(module.vpc.http_from_world_group_id,module.vpc.ssh_from_world_group_id,module.vpc.egress_to_world_group_id)}"
  name               = "${var.stack_name}-web"
}

# Outputs =======================================================

output "ip" {
  value = "${module.web.ip}"
}

