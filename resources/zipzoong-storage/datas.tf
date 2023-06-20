data "aws_iam_role" "backend_main" {
  name = "ECSTaskRole_ZipzoongBackendMain_production"
}

data "aws_iam_policy_document" "public_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
  statement {
    effect  = "Allow"
    actions = ["s3:PutObject"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.backend_main.arn]
    }
  }
}
