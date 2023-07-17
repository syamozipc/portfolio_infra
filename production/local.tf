locals {
  name      = "portfolio"
  env       = "production"
  terraform = true

  region = "ap-northeast-1"

  tags = {
    name      = local.name
    env       = local.env
    terraform = local.terraform
  }
}
