resource "aws_ecs_service" "this" {
  tags = {
    Name = "${var.service}-ecs-service-${var.name}"
  }
  name            = var.name
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  /** Deployment failure detection
  - alarms CloudWatch 경보
  - deployment_circuit_breaker 배포 회로 차단기
  - - 작업이 정상 상태에 도달하지 않을 경우 회로 차단기가 배포를 실패로 설정합니다.
  alarms {
    alarm_names = "deployment_alarm_name"
    enable      = true // 배포 프로세스에서 사용할지 말지
    rollback    = true // 서비스 배포에 실패하면 알람이 울리고 롤백을 자동으로 실행
  }
  */
  deployment_circuit_breaker {
    enable   = true
    rollback = true // 실패 시 롤백
  }
  deployment_controller {
    type = "ECS"
  }
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = false
  enable_execute_command             = false
  force_new_deployment               = true
  health_check_grace_period_seconds  = 30
  iam_role                           = null
  launch_type                        = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.container.name
    container_port   = var.container.port
  }
  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = data.aws_security_groups.container.ids
    assign_public_ip = false
  }
  platform_version    = "LATEST"
  propagate_tags      = "SERVICE"
  scheduling_strategy = "REPLICA"
  service_connect_configuration {
    enabled = false
  }
  wait_for_steady_state = true
}

resource "aws_lb" "this" {
  tags = {
    Name = "${var.service}-alb-${var.name}"
  }
  name                       = "${var.name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = data.aws_subnets.public.ids
  security_groups            = data.aws_security_groups.https.ids
  enable_deletion_protection = true
  enable_http2               = true
}

resource "aws_lb_target_group" "this" {
  name        = "${var.service}-${var.name}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.this.id
  health_check {
    protocol = "HTTP"
    path     = var.health_path
  }
}

resource "aws_lb_listener" "forward" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.this.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
