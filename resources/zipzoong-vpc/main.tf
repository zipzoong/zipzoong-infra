module "vpc" {
  source  = "../../modules/vpc"
  region  = local.region
  project = local.service
  sg = [{
    name = "https"
    inbound = [{
      port     = 80
      protocol = "tcp"
      }, {
      port     = 443
      protocol = "tcp"
    }]
    }, {
    name = "ssh"
    inbound = [{
      port     = 22
      protocol = "tcp"
    }]
    }, {
    name = "4000"
    inbound = [{
      port     = 4000
      protocol = "tcp"
    }]
    }, {
    name = "postgres"
    inbound = [{
      port     = 5432
      protocol = "tcp"
    }]
  }]
}
