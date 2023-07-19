resource "aws_ssm_parameter" "db_username" {
  name  = "/portfolio/production/db/username"
  type  = "String"
  value = aws_db_instance.this.username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/portfolio/production/db/password"
  type  = "SecureString"
  value = random_password.db_password.result
}
