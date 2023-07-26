module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.app_name}-${local.env}"
  cidr = "10.0.0.0/24"

  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]
  public_subnets  = ["10.0.0.128/28", "10.0.0.144/28", "10.0.0.160/28"]
}
