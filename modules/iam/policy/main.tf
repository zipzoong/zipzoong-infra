resource "aws_iam_policy" "this" {
  description = var.description
  name        = var.name
  path        = var.path
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [for stmts in var.statements : {
      Action   = stmts.actions
      Effect   = stmts.isAllow ? "Allow" : "Deny"
      Resource = stmts.resources
    }]
  })
}
