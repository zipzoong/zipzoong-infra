module "cluster" {
  source  = "../../modules/ecs/cluster"
  service = local.service
}

module "backend" {
  source      = "./backend"
  tag         = "1.0.0"
  cluster_arn = module.cluster.arn
}
