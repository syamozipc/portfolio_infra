locals {
  region    = "ap-northeast-1"
  name      = "portfolio"
  env       = "production"
  terraform = true

  domain_name        = "syamozipc.xyz"
  client_domain_name = "web-app.${local.domain_name}"
  server_domain_name = "web-app-api.${local.domain_name}"


  tags = {
    name      = local.name
    env       = local.env
    terraform = local.terraform
  }
}
