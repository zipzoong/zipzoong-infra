module "domain" {
  source = "../../modules/route53"
  name   = "zipzoong.co.kr"

  records = [{
    subdomain = "www"
    alias = {
      dns_name = ""
      zone_id  = ""
    }
    }, {
    subdomain = "api"
    alias = {
      dns_name = ""
      zone_id  = ""
    }
  }]
}
