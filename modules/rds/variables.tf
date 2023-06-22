variable "service" {
  type = string
}

variable "name" {
  type = string
}

variable "kms_key" {
  type = string
}

variable "auto_upgrade" {
  type = object({
    major = bool
    minor = bool
  })
  default = {
    major = false
    minor = false
  }
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "storage" {
  type = object({
    type      = string // standard, gp2, gp3, iops
    encrypted = bool
    min       = number
    max       = number
  })
  default = {
    type      = "gp2"
    encrypted = false
    min       = 20
    max       = 1000
  }
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "backup_period" {
  type    = number
  default = 0
}

variable "insight_period" {
  type    = number
  default = 0
}

variable "enhanced_monitoring_interval" {
  type    = number
  default = 0
}
