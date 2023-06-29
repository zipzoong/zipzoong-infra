variable "cluster_arn" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "container" {
  type = object({
    name = string
    port = number
  })
}

variable "service" {
  type = string
}

variable "name" {
  type = string
}

variable "health_path" {
  type = string
}

variable "domain" {
  type = string
}
