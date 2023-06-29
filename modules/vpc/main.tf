locals {
  public_cidr = "0.0.0.0/0"
  azs         = ["a", "b", "c", "d"]
  len_of_az   = min(length(var.public_subnets), length(var.private_subnets), length(local.azs))
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

resource "aws_subnet" "public" {
  tags = {
    Name = "${var.project}-public-subnet"
  }
  count                                          = local.len_of_az
  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(tolist(var.public_subnets), count.index)
  availability_zone                              = element([for az in local.azs : "${var.region}${az}"], count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
}

resource "aws_subnet" "private" {
  tags = {
    Name = "${var.project}-private-subnet"
  }
  count                                          = local.len_of_az
  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(tolist(var.private_subnets), count.index)
  availability_zone                              = element([for az in local.azs : "${var.region}${az}"], count.index)
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

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_default_security_group" "default" {
  tags = {
    Name = "${var.project}-sg-default"
  }
  vpc_id                 = aws_vpc.this.id
  revoke_rules_on_delete = false
}

resource "aws_security_group" "this" {
  count = length(var.sg)
  tags = {
    Name = join("-", [var.project, "sg", element(var.sg[*].name, count.index)])
  }
  vpc_id      = aws_vpc.this.id
  name        = element(var.sg[*].name, count.index)
  description = "allow ${element(var.sg[*].name, count.index)} inbound traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.public_cidr]
  }

  dynamic "ingress" {
    for_each = element(var.sg[*].inbound, count.index)

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = [local.public_cidr]
    }
  }
}
