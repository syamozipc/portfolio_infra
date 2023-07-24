resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "this" {
  identifier = "${local.app_name}-${local.env}"

  allocated_storage     = 20
  max_allocated_storage = 1000

  # 変更を即時適用させる
  apply_immediately = true

  engine               = "postgres"
  engine_version       = "14.7"
  instance_class       = "db.t3.micro"
  network_type         = "IPV4"
  parameter_group_name = "default.postgres14"

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  username = var.db_username
  password = random_password.db_password.result
  db_name  = "portfolio"
  port     = 5432

  skip_final_snapshot = true
  storage_encrypted   = true
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.app_name}-${local.env}-rds"
  subnet_ids = local.private_subnet_ids
}
