# cloudfrontのSSL証明書・DNS検証はvirginia regionでのみ作成可能
resource "aws_acm_certificate" "cloudfront" {
  provider = aws.virginia

  domain_name               = local.domain_name
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"
}

# 証明書のDNS検証の完了を検知する
resource "aws_acm_certificate_validation" "cloudfront" {
  provider = aws.virginia

  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_acm_validation : record.fqdn]
}

# cloudfront以外のSSL証明書・DNS検証完了通知はtokyo regionで作成
resource "aws_acm_certificate" "main" {
  domain_name               = local.domain_name
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.main_acm_validation : record.fqdn]
}
