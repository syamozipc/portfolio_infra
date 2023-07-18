resource "aws_security_group" "rds" {
  name = "${local.name}-${local.env}-rds-sg"
  # TODO:vpcをterraform化したら動的に修正
  vpc_id = local.vpc_id

  # ALBからの通信のみ
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # TODO:ALBをterraform化したら動的に修正
    security_groups = ["sg-09f74148688afb438"]
  }

  # 全て許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
