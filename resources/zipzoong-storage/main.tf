module "s3_public" {
  source        = "../../modules/s3"
  service       = local.service
  name          = "public"
  attach_policy = true
  policy        = data.aws_iam_policy_document.public_policy.json
}

module "s3_private" {
  source  = "../../modules/s3"
  service = local.service
  name    = "private"
}

module "s3_internal" {
  source  = "../../modules/s3"
  service = local.service
  name    = "internal"
}
