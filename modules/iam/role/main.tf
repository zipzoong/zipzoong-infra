resource "aws_iam_role" "this" {
  name                = var.name
  path                = var.path
  description         = var.description
  managed_policy_arns = [for policy in data.aws_iam_policy.this : policy.arn]
  assume_role_policy  = data.aws_iam_policy_document.this.json
}
