variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "azs" {
  type    = set(string)
  default = ["a", "b"]
}
