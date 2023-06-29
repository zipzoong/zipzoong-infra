data "aws_vpc" "this" {
  tags = {
    Name = "${var.service}-vpc"
  }
}

data "aws_security_groups" "https" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "${var.service}-sg-https"
  }
}

data "aws_security_groups" "container" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "${var.service}-sg-4000"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "${var.service}-private-subnet"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "${var.service}-public-subnet"
  }
}

data "aws_acm_certificate" "this" {
  domain   = var.domain
  statuses = ["ISSUED"]
}
