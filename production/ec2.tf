data "aws_ami" "this" {
  owners = ["amazon"]

  # Amazon Linux 2023
  filter {
    name   = "image-id"
    values = ["ami-0d3bbfd074edd7acb"]
  }
}

resource "aws_instance" "first" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = aws_key_pair.this.key_name

  user_data = templatefile(
    "init_ec2.sh",
    {
      work_dir    = "/root"
      app_name    = local.app_name
      db_host     = aws_db_instance.this.address
      db_port     = aws_db_instance.this.port
      db_name     = aws_db_instance.this.db_name
      db_user     = aws_db_instance.this.username
      db_password = random_password.db_password.result
    }
  )

  tags = {
    Name = "${local.app_name}-${local.env}-first"
  }
}

resource "aws_instance" "second" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[1]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = aws_key_pair.this.key_name


  user_data = templatefile(
    "init_ec2.sh",
    {
      work_dir    = "/root"
      app_name    = local.app_name
      db_host     = aws_db_instance.this.address
      db_port     = aws_db_instance.this.port
      db_name     = aws_db_instance.this.db_name
      db_user     = aws_db_instance.this.username
      db_password = random_password.db_password.result
    }
  )

  tags = {
    Name = "${local.app_name}-${local.env}-second"
  }
}

resource "aws_key_pair" "this" {
  key_name   = local.app_name
  public_key = file("key_pair/id_rsa.pub")
}
