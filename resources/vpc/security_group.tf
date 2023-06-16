resource "aws_default_security_group" "default" {
  tags = {
    Name = "${var.project}-sg-default"
  }
  vpc_id = aws_vpc.this.id
}
resource "aws_security_group" "allow_http" {
  tags = {
    Name = "${var.project}-sg-http"
  }
  name        = "allow_http"
  description = "allow http(s) inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.public_cidr]
  }
}

resource "aws_security_group" "allow_ssh" {
  tags = {
    Name = "${var.project}-sg-ssh"
  }
  name        = "allow_ssh"
  description = "allow ssh inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.public_cidr]
  }
}

resource "aws_security_group" "allow_4000" {
  tags = {
    Name = "${var.project}-sg-4000"
  }
  name        = "allow_4000"
  description = "allow 4000 inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.public_cidr]
  }
}
