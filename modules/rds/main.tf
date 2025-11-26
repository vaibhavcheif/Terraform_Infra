resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.project_name}-rds-subnets"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-rds-subnets"
  }
}

resource "aws_db_instance" "this" {
  identifier              = var.db_identifier
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet.name
  skip_final_snapshot     = true
  publicly_accessible     = false
}
