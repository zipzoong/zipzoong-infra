data "aws_kms_key" "this" {
  key_id = "alias/${var.kms_key}"
}

data "aws_vpc" "this" {
  tags = {
    Name = "${var.service}-vpc"
  }
}

data "aws_security_groups" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "${var.service}-sg-postgres"
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "${var.service}-private-subnet"
  }
}
