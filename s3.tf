resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "assets" {
  bucket        = "ims-assets-${random_id.bucket_suffix.hex}"
  force_destroy = true

  lifecycle {
    ignore_changes = [object_lock_enabled]
  }

  tags = {
    Name = "ims-assets"
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "assets" {
  bucket = aws_s3_bucket.assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.assets]
}

resource "aws_s3_object" "assets" {
  for_each = fileset("${path.module}/assets", "*")

  bucket       = aws_s3_bucket.assets.id
  key          = each.value
  source       = "${path.module}/assets/${each.value}"
  etag         = filemd5("${path.module}/assets/${each.value}")
  content_type = "image/png"
}