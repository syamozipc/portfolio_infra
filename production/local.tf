locals {
  name      = "portfolio"
  env       = "production"
  terraform = true

  tags = {
    name      = local.name
    env       = local.env
    terraform = local.terraform
  }
}
