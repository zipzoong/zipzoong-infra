variable "service" {
  type = string
}

variable "bucket" {
  type = string
}

variable "read-only" {
  type    = bool
  default = false
}

variable "acl" {
  type = string
  validation {
    condition     = var.acl == "private" || var.acl == "public-read" || var.acl == "public-read-write" || var.acl == "aws-exec-read" || var.acl == "authenticated-read" || var.acl == "log-delivery-write"
    error_message = "acl should be one of 'private' | 'public-read' | 'public-read-write' | 'aws-exec-read' | 'authenticated-read' | 'log-delivery-write'"
  }
  default = "private"
}

variable "version_status" {
  type = string
  validation {
    condition     = var.version_status == "Enabled" || var.version_status == "Suspended" || var.version_status == "Disabled"
    error_message = "version_status should be one of 'Enabled' | 'Suspended' | 'Disabled'"
  }
  default = "Disabled"
}

variable "public_access_block" {
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}
