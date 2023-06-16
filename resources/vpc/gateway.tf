resource "aws_eip" "nat" {
  tags = {
    Name = "${var.project}-eip-nat-a"
  }
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  tags = {
    Name = "${var.project}-nat-a"
  }
  subnet_id         = aws_subnet.public_a.id
  connectivity_type = "public"
  allocation_id     = aws_eip.nat.id
}
