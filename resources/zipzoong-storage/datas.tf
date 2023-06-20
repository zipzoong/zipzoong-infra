data "aws_iam_role" "backend_main" {
  name = "ECSTaskRole_ZipzoongBackendMain_production"
}

data "aws_iam_policy_document" "public_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [modoule.s3_public.aws_s3_bucket.this.arn]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = [modoule.s3_public.aws_s3_bucket.this.arn]
    principals {
      type        = "Service"
      identifiers = [data.aws_iam_role.backend_main.arn]
    }
  }
}
