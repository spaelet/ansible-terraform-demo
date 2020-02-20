
# AWS Provider ================================================

provider "aws" {
  region  = "us-east-1"
}

# Bucket ================================================

resource "aws_s3_bucket" "tfstate" {
  bucket = var.stack_name
  acl    = "private"
}

# Table ================================================

resource "aws_dynamodb_table" "tfstate" {
  name = var.stack_name
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}




