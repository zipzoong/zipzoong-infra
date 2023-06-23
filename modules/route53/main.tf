data "aws_route53_zone" "this" {
  name         = var.name
  private_zone = false
}

resource "aws_route53_record" "this" {
  for_each = toset(var.records)
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = join(".", [each.value.subdomain, data.aws_route53_zone.this.name])
  type     = "A"

  alias {
    name                   = each.value.alias.dns_name
    zone_id                = each.value.alias.zone_id
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
