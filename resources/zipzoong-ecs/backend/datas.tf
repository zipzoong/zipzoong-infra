data "aws_ecr_repository" "this" {
  name = "zipzoong_backend_main"
}

data "aws_iam_role" "execution" {
  name = "ECSTaskExecutionRole_ZipzoongBackendMain"
}

data "aws_iam_role" "task" {
  name = "ECSTaskRole_ZipzoongBackendMain"
}

data "aws_secretsmanager_secret" "this" {
  name = "zipzoong_production"
}
