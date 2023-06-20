variable "service" {
  type = string
}

variable "name" {
  type = string
}

variable "read-only" {
  type    = bool
  default = false
}

variable "version_status" {
  type = string
  validation {
    condition     = var.version_status == "Enabled" || var.version_status == "Suspended" || var.version_status == "Disabled"
    error_message = "version_status should be one of 'Enabled' | 'Suspended' | 'Disabled'"
  }
  default = "Disabled"
}

variable "attach_policy" {
  description = "(Optional) To apply a policy, you need to set 'attach_policy' to true. default is false"
  type        = bool
  default     = false
}

variable "policy" {
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}
