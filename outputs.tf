output "frontend_alb_dns" {
  value = aws_lb.frontend.dns_name
}

output "backend_alb_dns" {
  value = "http://${aws_lb.backend.dns_name}"
}

output "s3_bucket_url" {
  description = "S3 bucket URL"
  value       = "https://${aws_s3_bucket.assets.bucket}.s3.amazonaws.com"
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}