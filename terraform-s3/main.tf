terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

# create aws provider 
provider "aws" {
  region = "ap-south-1"
  secret_key = "xxxx"
  access_key = "xxxxx"
}

resource "aws_s3_bucket" "mybucket" {
   bucket =  "app.highskyit.com"
   tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}



resource "aws_s3_bucket_website_configuration" "blog" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.mybucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# resource "aws_s3_object" "upload_object" {
#   for_each      = fileset("finexo/", "*")
#   bucket        = aws_s3_bucket.mybucket.id
#   key           = each.value
#   source        = "finexo/${each.value}"
#   etag          = filemd5("finexo/${each.value}")
#   content_type  = "text/html"
# }

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 cp finexo/ s3://${aws_s3_bucket.mybucket.id} --recursive"
  }
}
resource "aws_s3_bucket_policy" "hosting-bucket-policy" {
  bucket = aws_s3_bucket.mybucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::app.highskyit.com/*"
        }
    ]
  })
}