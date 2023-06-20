module "s3_public" {
  source        = "../../modules/s3"
  service       = local.service
  name          = "public"
  attach_policy = true
  policy_statements = [{
    allow          = true
    actions        = ["s3:GetObject"]
    resource_paths = ["*"]
    all_principals = true
    }, {
    allow          = true
    actions        = ["s3:PutObject"]
    resource_paths = ["*"]
    aws_principals = [data.aws_iam_role.backend_main.arn]
  }]
}

module "s3_private" {
  source        = "../../modules/s3"
  service       = local.service
  name          = "private"
  attach_policy = true
  policy_statements = [{
    allow          = true
    actions        = ["s3:PutObject", "s3:GetObject"]
    resource_paths = ["*"]
    aws_principals = [data.aws_iam_role.backend_main.arn]
  }]
}

module "s3_internal" {
  source  = "../../modules/s3"
  service = local.service
  name    = "internal"
}
