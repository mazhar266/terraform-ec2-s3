# s3 bucket for file upload
resource "aws_s3_bucket" "b" {
  bucket = "bucket name here"
  acl    = "public-read"
  region = "your region"
  policy = "${file("s3-policy.json")}"
tags = {
    Name = "project name"
    Mode = "dev"
  }
}
