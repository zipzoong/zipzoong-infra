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
    action          = "allow"
    cidr_block      = local.public_cidr
    from_port       = 0
    ipv6_cidr_block = null
    protocol        = "-1"
    rule_no         = 100
    to_port         = 0
  }

  egress {
    action          = "allow"
    cidr_block      = local.public_cidr
    from_port       = 0
    icmp_code       = 0
    icmp_type       = 0
    ipv6_cidr_block = null
    protocol        = "-1"
    rule_no         = 100
    to_port         = 0
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_subnet" "public_a" {
  tags = {
    Name = "${var.project}-public-subnet-a"
  }
  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "${var.region}a"
  cidr_block                                     = "10.0.0.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
}

resource "aws_subnet" "public_b" {
  tags = {
    Name = "${var.project}-public-subnet-b"
  }
  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "${var.region}b"
  cidr_block                                     = "10.0.16.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
}

resource "aws_subnet" "private_a" {
  tags = {
    Name = "${var.project}-private-subnet-a"
  }
  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "${var.region}a"
  cidr_block                                     = "10.0.128.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
}

resource "aws_subnet" "private_b" {
  tags = {
    Name = "${var.project}-private-subnet-b"
  }
  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "${var.region}b"
  cidr_block                                     = "10.0.144.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
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
