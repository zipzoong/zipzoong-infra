resource "aws_db_instance" "this" {
  allocated_storage             = var.allocated_storage     //200 GiB
  max_allocated_storage         = var.max_allocated_storage // 1000 GiB
  apply_immediately             = var.apply_immediately
  allow_major_version_upgrade   = var.allow_major_auto_upgrade
  auto_minor_version_upgrade    = var.allow_minor_auto_upgrade
  availability_zone             = d
  db_name                       = "${var.service}-${var.db_name}"
  engine                        = "postgresql"
  engine_version                = "14.8"
  instance_class                = var.instance_class //"db.m5.large"
  username                      = "postgres"
  master_user_secret_kms_key_id = data.aws_kms_key.this.key_id
}

resource "aws_security_group" "this" {
  tags = {
    Name = "${var.service}-sg-postgresql"
  }
  name        = "allow_ssh"
  description = "allow ssh inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [local.public_cidr]
  }
}
