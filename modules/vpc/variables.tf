variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "public_subnets" {
  type    = set(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnets" {
  type    = set(string)
  default = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "sg" {
  type = list(object({
    name = string
    inbound = list(object({
      port     = number
      protocol = string
    }))
  }))

  default = []
}
