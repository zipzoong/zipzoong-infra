variable "region" {
  type = string
}
variable "project" {
  type = string
}

variable "public_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

