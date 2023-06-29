locals {
  secret_keys = [
    "DATABASE_URL",
    "ACCOUNT_TOKEN_KEY",
    "ACCESS_TOKEN_KEY",
    "REFRESH_TOKEN_KEY",
    "KAKAO_CLIENT_ID",
    "KAKAO_CLIENT_SECRET",
    "NAVER_SENS_ACCESS_KEY",
    "NAVER_SENS_SECRET_KEY"
  ]

  container = {
    name = "main"
    port = 4000
  }

  domain = "zipzoong.co.kr"
}

module "task_definition" {
  source             = "../../../modules/ecs/container"
  family             = "zipzoong_backend_main_production"
  cpu_core           = 2
  ram                = 8
  execution_role_arn = data.aws_iam_role.execution.arn
  task_role_arn      = data.aws_iam_role.task.arn
  container_definitions = [{
    name  = local.container.name
    image = join(":", [data.aws_ecr_repository.this.repository_url, var.tag])
    portMappings = [{
      name          = join("-", [local.container.name, local.container.port, "tcp"])
      containerPort = local.container.port
      hostPort      = local.container.port
      protocol      = "tcp"
      appProtocol   = "http"
    }]
    environment = [{
      name  = "NODE_ENV"
      value = "production"
      }, {
      name  = "AWS_REGION"
      value = "ap-northeast-2"
      }, {
      name  = "AWS_LOG_GROUP"
      value = "/zipzoong/backend/main"
      }, {
      name  = "AWS_S3"
      value = "zipzoong"
      }, {
      name  = "NAVER_SENS_CALLER"
      value = "01077723010"
      }, {
      name  = "NAVER_SENS_HOST"
      value = "https://sens.apigw.ntruss.com"
      }, {
      name  = "NAVER_SENS_SERVICE_ID"
      value = "ncp:sms:kr:264473442036:zipzoong"
      }, {
      name  = "KAKAO_REDIRECT_URI"
      value = "https://www.zipzoong.co.kr/oauth/kakao"
    }]
    secrets = [for key in local.secret_keys : { name = key, valueFrom = "${data.aws_secretsmanager_secret.this.arn}:${key}::" }]
  }]
}

module "service" {
  source              = "../../../modules/ecs/service"
  service             = "zipzoong"
  name                = "backend"
  cluster_arn         = var.cluster_arn
  task_definition_arn = module.task_definition.arn_with_revision
  container           = local.container
  health_path         = "/health-check"
  domain              = local.domain

  depends_on = [module.task_definition]
}

module "domain" {
  source = "../../../modules/route53"

  name = local.domain
  records = [{ subdomain = "api", alias = {
    dns_name = module.service.dns_name
    zone_id  = module.service.zone_id
  } }]

  depends_on = [module.service]
}
