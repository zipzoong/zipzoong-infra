variable "name" {
  type    = string
  default = "test"
}

variable "description" {
  type    = string
  default = null
}

variable "path" {
  type    = string
  default = "/"
}

variable "statements" {
  type = list(object({
    isAllow   = bool
    actions   = set(string)
    resources = set(string)
  }))

  default = [{
    actions   = ["ec2:Describe*"]
    isAllow   = true
    resources = ["*"]
  }]
}
