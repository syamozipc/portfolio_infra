resource "aws_s3_bucket" "this" {
  bucket = "${local.name}-${local.env}-client"
  # doestroy時、objectが空でなくても成功させる
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  # 常にindex.htmlを返す
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  # data属性に切り出すことも可能だが、applyの都度差分として表示されて余計なので直接埋め込む
  policy = <<EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "${aws_s3_bucket.this.arn}/*",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceArn": "${aws_cloudfront_distribution.this.arn}"
                    }
                }
            }
        ]
    }
  EOT
}
