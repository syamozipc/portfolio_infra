# 静的websiteホスティングの選択肢もあるが、S3にhttpで直接接続できる仕様でcloudfrontからのみの接続に制限できないため、REST API endpointを使用する
# https://log.dot-co.co.jp/cloudfront-s3-statichosting/#i-10
# https://horizoon.jp/post/2021/09/05/s3_website_hosting/
resource "aws_s3_bucket" "this" {
  bucket = "${local.app_name}-${local.env}-client"
  # doestroy時、objectが空でなくても成功させる
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  # data属性に切り出すことも可能だが、applyの都度差分として表示されて余計なので直接埋め込む
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : ["s3:GetObject"],
        "Resource" : "${aws_s3_bucket.this.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.this.arn
          }
        }
      }
    ]
  })
}
