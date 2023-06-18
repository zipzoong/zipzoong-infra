resource "aws_s3_bucket" "this" {
  tags = {
    Name = "${var.service}-s3-${var.bucket}"
  }

  bucket              = "${var.service}-${var.bucket}"
  force_destroy       = false
  object_lock_enabled = var.read-only
}


resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.version_status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

/**
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
object_ownership = "Bucket"
  }
}
*/

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.public_access_block.block_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]

  bucket = aws_s3_bucket.this.id
  acl    = var.acl
}
