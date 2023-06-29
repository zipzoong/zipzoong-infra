variable "family" {
  type = string
}

variable "container_definitions" {
  type = list(object({
    command = optional(list(string))
    cpu     = optional(number, 0)
    environment = optional(list(object({
      name  = string
      value = string
    })), [])
    essential = optional(bool, true)
    image     = string
    name      = string
    portMappings = list(object({
      name          = string
      containerPort = number
      hostPort      = number
      protocol      = string
      appProtocol   = string
    }))
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })), [])
  }))
}

variable "cpu_core" {
  type    = number
  default = 1
}

variable "ram" {
  type    = number
  default = 2
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}
