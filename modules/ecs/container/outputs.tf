output "arn_with_revision" {
  value = aws_ecs_task_definition.this.arn
}

output "arn_without_revision" {
  value = aws_ecs_task_definition.this.arn_without_revision
}
