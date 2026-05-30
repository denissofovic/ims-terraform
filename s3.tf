resource "aws_s3_bucket" "assets" {
  bucket        = "ims-assets-sofovic"
  force_destroy = true

  lifecycle {
    ignore_changes  = [object_lock_enabled]
    prevent_destroy = false
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
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.assets.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.assets]
}

resource "aws_s3_object" "dccs_png" {
  bucket       = aws_s3_bucket.assets.id
  key          = "dccs.png"
  source       = "${path.module}/assets/dccs.png"
  etag         = filemd5("${path.module}/assets/dccs.png")
  content_type = "image/png"
}

resource "aws_s3_object" "dccs_svg" {
  bucket       = aws_s3_bucket.assets.id
  key          = "dccs.svg"
  source       = "${path.module}/assets/dccs.svg"
  etag         = filemd5("${path.module}/assets/dccs.svg")
  content_type = "image/svg+xml"
}