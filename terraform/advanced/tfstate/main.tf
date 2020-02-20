
# AWS Provider ================================================

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Bucket ================================================

resource "aws_s3_bucket" "bucket" {
  bucket = "spaelet-tfstate-advanced"
  acl    = "private"
}

# Table ================================================

resource "aws_dynamodb_table" "tfstate" {
  name = "tfstate-advanced"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}




