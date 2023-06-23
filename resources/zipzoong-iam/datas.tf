data "aws_kms_key" "this" {
  key_id = "alias/zipzoong_production_kms"
}

data "aws_ecr_repository" "zipzoong_backend_main" {
  name = "zipzoong_backend_main"
}

data "aws_cloudwatch_log_group" "zipzoong_backend_main" {
  name = "/zipzoong/backend/main"
}

data "aws_secretsmanager_secret" "zipzoong_production" {
  name = "zipzoong_production"
}
