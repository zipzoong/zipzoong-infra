module "s3_public" {
  source  = "../../modules/s3"
  service = local.service
  bucket  = "public"
  acl     = "public-read"
  public_access_block = {
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = true
  }
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
