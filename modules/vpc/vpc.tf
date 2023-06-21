locals {
  public_cidr = "0.0.0.0/0"
}

resource "aws_vpc" "this" {
  tags = {
    Name = "${var.project}-vpc"
  }
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_default_network_acl" "default" {
  tags = {
    Name = "${var.project}-acl-default"
  }
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.public_cidr
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.public_cidr
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_subnet" "public_a" {
  tags = {
    Name = "${var.project}-public-subnet-a"
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "public_b" {
  tags = {
    Name = "${var.project}-public-subnet-b"
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "private_a" {
  tags = {
    Name = "${var.project}-private-subnet-a"
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "private_b" {
  tags = {
    Name = "${var.project}-private-subnet-b"
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "${var.region}b"
}

resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "${var.project}-igw"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_default_route_table" "default" {
  tags = {
    Name = "${var.project}-rtb-default"
  }

  default_route_table_id = aws_vpc.this.default_route_table_id
  propagating_vgws       = []
}

resource "aws_route_table" "public" {
  tags = {
    Name = "${var.project}-rtb-public"
  }

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.public_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  tags = {
    Name = "${var.project}-rtb-private"
  }

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = local.public_cidr
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
