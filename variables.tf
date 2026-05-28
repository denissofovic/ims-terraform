variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
  default     = "theonepieceisreal"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "InventorySystem"
}

variable "backend_url" {
  description = "Backend ALB DNS name"
  type        = string
  default     = "http://backend-alb-160691908.us-east-1.elb.amazonaws.com"
}

variable "s3_url" {
  description = "S3 bucket URL for assets"
  type        = string
  default     = "https://ims-assets-sofovic.s3.amazonaws.com"
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/denissofovic/inventory-managment-system.git"
}

variable "db_host" {
  description = "Hostname for RDS DB"
  type = string
  default = "ims-database.c805x3fvhurr.us-east-1.rds.amazonaws.com:5432"
}