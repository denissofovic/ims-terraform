resource "aws_launch_template" "backend" {
  name_prefix   = "backend-template-"
  image_id      = "ami-0c02fb55956c7d316" 
  instance_type = "t2.small"
  key_name      = "vockey"

  vpc_security_group_ids = [aws_security_group.backend.id]

  user_data = base64encode(templatefile("${path.module}/scripts/user_data_backend.sh", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "backend-instance"
    }
  }
}

resource "aws_launch_template" "frontend" {
  name_prefix   = "frontend-template-"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.small"
  key_name      = "vockey"

  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data = base64encode(templatefile("${path.module}/scripts/user_data_frontend.sh", {
    backend_url = var.backend_url
    s3_url      = var.s3_url
  }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "frontend-instance"
    }
  }
}