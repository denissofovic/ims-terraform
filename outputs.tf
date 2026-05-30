output "frontend_alb_dns" {
  value = aws_lb.frontend.dns_name
}

output "backend_alb_dns" {
  value = "http://${aws_lb.backend.dns_name}"
}

output "s3_bucket_url" {
  value = "https://ims-assets-9780cb22.s3.amazonaws.com"
} 

output "rds_endpoint" {
  value = split(":", aws_db_instance.main.endpoint)[0]
}