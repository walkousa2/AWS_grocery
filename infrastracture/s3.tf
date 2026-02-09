resource "aws_s3_bucket" "avatars" {
  bucket = var.avatars_bucket_name

  tags = {
    Name        = var.avatars_bucket_name
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "avatars" {
  bucket = aws_s3_bucket.avatars.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

