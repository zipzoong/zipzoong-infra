resource "aws_s3_bucket" "this" {
  tags = {
    Name = join("-", [var.service, "s3"])
  }
  bucket              = var.name == null ? var.service : "${var.service}-${var.name}"
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

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = !contains(flatten([for stmts in var.policy_statements : stmts.actions]), "s3:PutObject")
  restrict_public_buckets = !var.attach_policy

  depends_on = [aws_s3_bucket.this]
}

resource "aws_s3_bucket_policy" "this" {
  count = var.attach_policy ? 1 : 0

  # Chain resources (s3_bucket -> s3_bucket_public_access_block -> s3_bucket_policy )
  # to prevent "A conflicting conditional operation is currently in progress against this resource."
  # Ref: https://github.com/hashicorp/terraform-provider-aws/issues/7628

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
