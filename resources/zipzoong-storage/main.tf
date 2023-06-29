module "service" {
  source        = "../../modules/s3"
  service       = local.service
  attach_policy = true
  policy_statements = [{
    allow          = true
    actions        = ["s3:GetObject"]
    resource_paths = ["arn:aws:s3:::${local.service}/public/*"]
    principals = {
      "*" = ["*"]
    }
    }, {
    allow          = true
    actions        = ["s3:GetObject"]
    resource_paths = ["*"]
    principals = {
      "AWS" = [data.aws_iam_role.backend_main.arn]
    }
    }, {
    allow          = true
    actions        = ["s3:PutObject"]
    resource_paths = ["*"]
    principals = {
      "AWS" = [data.aws_iam_role.backend_main.arn]
    }
  }]
}

module "internal" {
  source  = "../../modules/s3"
  service = local.service
  name    = "internal"
}
