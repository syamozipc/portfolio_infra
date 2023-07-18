data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  # CNAME
  aliases = [local.client_domain_name]

  # s3に存在しないファイルのパスを指定された場合にrootをリクエスト（S3側でrootアクセスにはindex.htmlを返すよう設定済み）
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    # 圧縮して返す（リクエストヘッダーにAccept-Encoding: gzipがある場合のみ）
    compress = true

    cache_policy_id = data.aws_cloudfront_cache_policy.this.id

    target_origin_id = aws_s3_bucket.this.id

    # httpリクエストはhttpsへ301リダイレクト
    viewer_protocol_policy = "redirect-to-https"
  }

  # エンドユーザーからのリクエストを受けるかどうか
  enabled = true

  origin {
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = aws_s3_bucket.this.id

    origin_shield {
      enabled              = true
      origin_shield_region = local.region
    }
  }

  restrictions {
    # コンテンツのリクエストをできる国を制限
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
