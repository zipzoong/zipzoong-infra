variable "service" {
  type = string
}

variable "name" {
  type    = string
  default = null
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
  type    = bool
  default = false
}

variable "policy_statements" {
  type = list(object({
    allow          = bool
    actions        = list(string)
    resource_paths = list(string)
    principals     = map(set(string))
  }))
  description = "principals key is one of AWS, Service, Federated, CanonicalUser, *"
  default     = []
}
