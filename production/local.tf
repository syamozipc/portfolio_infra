locals {
  region    = "ap-northeast-1"
  app_name  = "portfolio"
  env       = "production"
  terraform = true

  domain_name        = "syamozipc.xyz"
  client_domain_name = "web-app.${local.domain_name}"
  server_domain_name = "web-app-api.${local.domain_name}"

  tags = {
    Name      = local.app_name
    Env       = local.env
    Terraform = local.terraform
  }
}
