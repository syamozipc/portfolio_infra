data "aws_route53_zone" "this" {
  name = local.domain_name
}

# cloudfrontのACM certificateのDNS検証用CNAMEを作成
resource "aws_route53_record" "cloudfront_acm_validation" {
  # resource自体をループして複数作成
  for_each = {
    # for_eachでループするための要素をマップして作成（index => domain object）
    for record in aws_acm_certificate.cloudfront.domain_validation_options : record.domain_name => {
      name   = record.resource_record_name
      record = record.resource_record_value
      type   = record.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  # 複数レコード登録時、レコード名が被るのでtrueにしないと重複エラーが出る
  allow_overwrite = true
}
