data "aws_iam_policy_document" "this" {
  count   = length(var.policy_statements) > 0 ? 1 : 0
  version = "2012-10-17"
  dynamic "statement" {
    for_each = var.policy_statements
    iterator = "statement"
    content {
      effect    = statement.allow ? "Allow" : "Deny"
      actions   = statement.value.actions
      resources = [for path in toset(statement.value.resource_paths) : "${aws_s3_bucket.this.arn}/${path}"]
      dynamic "principals" {
        for_each = statement.principals
        iterator = "principal"
        content {
          type        = principal.key
          identifiers = principal.value
        }
      }
    }
  }
}
