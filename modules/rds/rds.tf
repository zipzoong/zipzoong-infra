resource "aws_db_instance" "this" {
  tags = {
    Name = "${var.service}-db-${var.name}"
  }
  engine                      = "postgres"
  engine_version              = "14"
  instance_class              = var.instance_class //"db.m5.large"
  allow_major_version_upgrade = var.auto_upgrade.major
  auto_minor_version_upgrade  = var.auto_upgrade.minor
  allocated_storage           = var.storage.min //200 GiB
  max_allocated_storage       = var.storage.max // 1000 GiB
  storage_encrypted           = var.storage.encrypted
  storage_type                = var.storage.type
  network_type                = "IPV4"
  port                        = 5432
  publicly_accessible         = false
  vpc_security_group_ids      = data.aws_security_groups.this.ids
  db_subnet_group_name        = aws_db_subnet_group.this.name
  ca_cert_identifier          = "rds-ca-2019" // default
  multi_az                    = var.multi_az

  identifier                          = "${var.service}-${var.name}"
  db_name                             = var.name
  username                            = "postgres"
  manage_master_user_password         = true
  master_user_secret_kms_key_id       = data.aws_kms_key.this.key_id
  iam_database_authentication_enabled = false

  blue_green_update {
    enabled = false
  }
  apply_immediately        = var.apply_immediately
  backup_window            = "15:00-15:30"
  maintenance_window       = "Sun:02:00-Sun:05:00"
  backup_retention_period  = var.backup_period // default 0
  delete_automated_backups = true
  deletion_protection      = true
  skip_final_snapshot      = true
  copy_tags_to_snapshot    = false
  // final_snapshot_identifier = null

  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  monitoring_interval                   = var.enhanced_monitoring_interval
  performance_insights_enabled          = var.insight_period > 0 ? true : false
  performance_insights_kms_key_id       = var.insight_period > 0 ? data.aws_kms_key.this.arn : null
  performance_insights_retention_period = var.insight_period

}

resource "aws_db_subnet_group" "this" {
  name       = "${var.service}-${var.name}"
  subnet_ids = data.aws_subnets.this.ids
}
