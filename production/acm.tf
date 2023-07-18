resource "aws_acm_certificate" "cloudfront" {
  domain_name               = local.domain_name
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"

  # cloudfrontのACMはvirginia regionでのみ作成可能
  provider = aws.virginia
}

# ACM certifilateのDNS検証の完了を検知する
resource "aws_acm_certificate_validation" "cloudfront" {
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_acm_validation : record.fqdn]
  provider                = aws.virginia
}
