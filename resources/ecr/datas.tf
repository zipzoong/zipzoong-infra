data "aws_kms_key" "this" {
  key_id = "alias/${var.kms_key}"
}
