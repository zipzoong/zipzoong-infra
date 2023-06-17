module "vpc" {
  source  = "../../modules/vpc"
  region  = local.region
  project = local.service
}
