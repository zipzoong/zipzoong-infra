variable "name" {
  type = string
}

variable "path" {
  type    = string
  default = "/"
}

variable "description" {
  type    = string
  default = null
}

variable "policy_names" {
  type    = set(string)
  default = []
}

variable "assume_statements" {
  type = list(object({
    isAllow    = bool
    actions    = set(string)
    principals = map(set(string))
    conditions = set(object({
      test     = string
      variable = string
      values   = set(string)
    }))
  }))
}
