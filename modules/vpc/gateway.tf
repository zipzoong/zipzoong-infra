resource "aws_eip" "nat" {
  tags = {
    Name = "${var.project}-eip-nat"
  }
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "this" {
  tags = {
    Name = "${var.project}-nat"
  }
  subnet_id         = aws_subnet.public[0].id
  connectivity_type = "public"
  allocation_id     = aws_eip.nat.id
  depends_on        = [aws_internet_gateway.igw]
}
