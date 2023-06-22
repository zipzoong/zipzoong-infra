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

