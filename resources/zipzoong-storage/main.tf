module "s3_public" {
  source  = "../../modules/s3"
  service = local.service
  bucket  = "public"
}

module "s3_private" {
  source  = "../../modules/s3"
  service = local.service
  bucket  = "private"
}

module "s3_internal" {
  source  = "../../modules/s3"
  service = local.service
  bucket  = "internal"
}
