data "aws_iam_policy" "this" {
  for_each = var.policy_names
  name     = each.value
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  dynamic "statement" {
    for_each = toset(var.assume_statements)
    content {
      effect  = statement.value.isAllow ? "Allow" : "Deny"
      actions = statement.value.actions
      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.key
          identifiers = principals.value
        }
      }
      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
