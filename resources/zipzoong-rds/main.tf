module "main" {
  source  = "../../modules/rds"
  service = local.service
  name    = "main"
  auto_upgrade = {
    major = false
    minor = true
  }
  instance_class               = "db.t3.micro"
  multi_az                     = true
  apply_immediately            = false
  backup_period                = 7
  insight_period               = 0
  enhanced_monitoring_interval = 60
  kms_key                      = "${local.service}_production_kms"
}
