data "aws_iam_policy_document" "this" {
  count   = length(var.policy_statements) > 0 ? 1 : 0
  version = "2012-10-17"
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect    = policy_statement.value.allow ? "Allow" : "Deny"
      actions   = policy_statement.value.actions
      resources = [for path in toset(policy_statement.value.resource_paths) : "${aws_s3_bucket.this.arn}/${path}"]
      dynamic "principals" {
        for_each = policy_statement.principals
        content {
          type        = principal.key
          identifiers = principal.value
        }
      }
    }
  }
}
