resource "aws_security_group" "rds" {
  name = "${local.name}-${local.env}-rds-sg"
  # TODO:vpcをterraform化したら動的に修正
  vpc_id = local.vpc_id

  # EC2からの通信のみ
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  # 全て許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2" {
  name = "${local.name}-${local.env}-ec2-sg"
  # TODO:vpcをterraform化したら動的に修正
  vpc_id = local.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    # TODO:ALBをterraform化したら動的に修正
    security_groups = ["sg-088cf4af5e5244a1c"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 全て許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
