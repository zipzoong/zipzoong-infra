module "terraform_assumed_role" {
  source       = "../../modules/iam/role"
  name         = "TerraformAssumedRole"
  description  = "Role for managing permissions in Terraform"
  policy_names = ["AdministratorAccess"]
  assume_statements = [{
    isAllow = true
    actions = ["sts:AssumeRole"]
    principals = {
      "AWS" : [
        "arn:aws:iam::014987406633:user/zipzoong",
        "arn:aws:iam::014987406633:user/rojiwon"
      ]
    }
    conditions = []
  }]
}

module "terraform_managing_policy" {
  source = "../../modules/iam/policy"
  name   = "TerraformManagingPolicy"
  statements = [{
    isAllow = true
    actions = [
      "iam:PassRole"
    ]
    resources = [module.terraform_assumed_role.arn]
  }]

  depends_on = [module.terraform_assumed_role]
}

module "zipzoong_backend_main_put_log_event_policy" {
  source      = "../../modules/iam/policy"
  name        = "PutLogEvent_ZipzoongBackendMain"
  description = "Policy for putting cloudwatch log event to log group zipzoong/backend/main"
  statements = [{
    isAllow   = true
    actions   = ["logs:PutLogEvents"]
    resources = ["${data.aws_cloudwatch_log_group.zipzoong_backend_main.arn}:log-stream:production"]
  }]
}

module "zipzoong_backend_main_ecs_task_role" {
  source       = "../../modules/iam/role"
  name         = "ECSTaskRole_ZipzoongBackendMain"
  description  = "Role for granting permissions to ECS containers"
  policy_names = [module.zipzoong_backend_main_put_log_event_policy.name]
  assume_statements = [{
    isAllow    = true
    actions    = ["sts:AssumeRole"]
    principals = { "Service" : ["ecs-tasks.amazonaws.com"] }
    conditions = []
  }]

  depends_on = [module.zipzoong_backend_main_put_log_event_policy]
}

module "zipzoong_production_read_secret_key_policy" {
  source      = "../../modules/iam/policy"
  name        = "ReadSecretKey_ZipzoongBackendMain"
  description = "Policy for reading secretkey manager zipzoong_production"
  statements = [{
    isAllow   = true
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [data.aws_secretsmanager_secret.zipzoong_production.arn]
    }, {
    isAllow   = true
    actions   = ["kms:Decrypt"]
    resources = [data.aws_kms_key.this.arn]
  }]
}

module "zipzoong_backend_main_ecs_task_execution_role" {
  source       = "../../modules/iam/role"
  name         = "ECSTaskExecutionRole_ZipzoongBackendMain"
  description  = "Role for granting permissions required during ECS container initialization."
  policy_names = ["AmazonECSTaskExecutionRolePolicy", module.zipzoong_production_read_secret_key_policy.name]
  assume_statements = [{
    isAllow = true
    actions = ["sts:AssumeRole"]
    principals = {
      "Service" : ["ecs-tasks.amazonaws.com"]
    }
    conditions = []
  }]
  depends_on = [module.zipzoong_production_read_secret_key_policy]
}

module "zipzoong_backend_main_push_image_policy" {
  source      = "../../modules/iam/policy"
  name        = "PushImage_ZipzoongBackendMain"
  description = "Policy for pushing docker image to zipzoong backend main ecr"
  statements = [{
    isAllow = true
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = [data.aws_ecr_repository.zipzoong_backend_main.arn]
    }, {
    isAllow   = true
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
    }, {
    isAllow   = true
    actions   = ["kms:Decrypt"]
    resources = [data.aws_kms_key.this.arn]
  }]
}

module "zipzoong_backend_main_push_image_role" {
  source       = "../../modules/iam/role"
  name         = "PushImage_ZipzoongBackendMain"
  description  = "Role for granting ECR image push permissions in GitHub Actions"
  policy_names = [module.zipzoong_backend_main_push_image_policy.name]
  assume_statements = [{
    isAllow = true
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals = {
      "Federated" = ["arn:aws:iam::014987406633:oidc-provider/token.actions.githubusercontent.com"]
    }
    conditions = [{
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }]
  }]
  depends_on = [module.zipzoong_backend_main_push_image_policy]
}
