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

variable "policy_statements" {
  type = list(object({
    allow                    = bool
    actions                  = list(string)
    resource_paths           = list(string)
    all_principals           = bool
    aws_principals           = list(string)
    service_principals       = list(string)
    federated_principals     = list(string)
    canonicaluser_principals = list(string)
  }))

  default = []
}
