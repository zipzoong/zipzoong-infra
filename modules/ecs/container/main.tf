resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  container_definitions    = jsonencode(var.container_definitions)
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu_core * 1024
  memory                   = var.ram * 1024
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  skip_destroy = false
}
