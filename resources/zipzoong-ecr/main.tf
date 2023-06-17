module "ecr_backend_main" {
  source  = "../../modules/ecr"
  name    = "${local.service}_backend_main"
  kms_key = "${local.service}_production_kms"
}
