data "aws_iam_policy_document" "this" {
  count   = length(var.policy_statements) > 0 ? 1 : 0
  version = "2012-10-17"
  dynamic "statement" {
    for_each = var.policy_statements

    content {
      effect    = policy_statement.allow ? "Allow" : "Deny"
      actions   = policy_statement.actions
      resources = [for path in toset(policy_statement.resource_paths) : "${aws_s3_bucket.this.arn}/${path}"]
      dynamic "principals" {
        for_each = policy_statement.all_principals ? [{}] : []
        content {
          type        = "*"
          identifiers = ["*"]
        }
      }
      dynamic "principals" {
        for_each = policy_statement.all_principals ? [] : [{}]
        content {
          type        = "AWS"
          identifiers = toset(policy_statement.aws_principals)
        }
      }
      dynamic "principals" {
        for_each = policy_statement.all_principals ? [] : [{}]
        content {
          type        = "Service"
          identifiers = toset(policy_statement.service_principals)
        }
      }
      dynamic "principals" {
        for_each = policy_statement.all_principals ? [] : [{}]
        content {
          type        = "Federated"
          identifiers = toset(policy_statement.federated_principals)
        }
      }
      dynamic "principals" {
        for_each = policy_statement.all_principals ? [] : [{}]
        content {
          type        = "CanonicalUser"
          identifiers = toset(policy_statement.canonicaluser_principals)
        }
      }
    }
  }
}
