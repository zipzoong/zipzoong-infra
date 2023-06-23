resource "aws_ecr_repository" "this" {
  name                 = var.name
  force_delete         = false
  image_tag_mutability = "IMMUTABLE"


  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = data.aws_kms_key.this.arn
  }
}
