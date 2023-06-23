data "aws_route53_zone" "this" {
  name         = var.name
  private_zone = false
}

resource "aws_route53_record" "this" {
  count   = length(var.records)
  zone_id = data.aws_route53_zone.this.zone_id
  name    = join(".", [element(var.records[*].subdomain, count.index), data.aws_route53_zone.this.name])
  type    = "A"

  alias {
    name                   = element(var.records[*].alias.dns_name, count.index)
    zone_id                = element(var.records[*].alias.zone_id, count.index)
    evaluate_target_health = true
  }

}

variable "name" {
  type = string
}

variable "records" {
  type = list(object({
    subdomain = string
    alias = object({
      dns_name = string
      zone_id  = string
    })
  }))

  default = []
}
