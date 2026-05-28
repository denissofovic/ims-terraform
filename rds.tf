resource "aws_db_subnet_group" "main" {
  name = "ims-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "ims-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier = "ims-database"

  engine         = "postgres"
  engine_version = "17"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type       = "gp2"
  storage_encrypted  = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  publicly_accessible = false
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "ims-database"
  }
}