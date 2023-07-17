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
  policy = data.aws_iam_policy_document.s3_bucket.json
}

data "aws_iam_policy_document" "s3_bucket" {
  version = "2012-10-17"
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.this.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      # TODO::動的にする
      values   = ["arn:aws:cloudfront::009317091415:distribution/E2VGE9EBQ3JBU5"]
    }
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}