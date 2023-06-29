resource "aws_ecs_cluster" "this" {
  tags = {
    Name = "${var.service}-ecs-cluster"
  }
  name = var.service
}
