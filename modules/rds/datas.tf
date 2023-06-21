data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
}

data "aws_kms_key" "this" {
  key_id = "alias/${var.kms_key}"
}
