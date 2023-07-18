locals {
  region    = "ap-northeast-1"
  name      = "portfolio"
  env       = "production"
  terraform = true

  domain_name        = "syamozipc.xyz"
  client_domain_name = "web-app.${local.domain_name}"
  server_domain_name = "web-app-api.${local.domain_name}"

  # TODO:vpcをterraform化したら動的に修正
  vpc_id     = "vpc-0931b2de5ac2ea3a5"
  subnet_ids = ["subnet-0c52ea815c78afeb2", "subnet-0b23ae07ff17c344f"]

  tags = {
    name      = local.name
    env       = local.env
    terraform = local.terraform
  }
}
