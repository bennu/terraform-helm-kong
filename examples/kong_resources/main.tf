module kong {
  source = "../../"

  db_host   = var.db_host
  db_name   = var.db_name
  db_pass   = var.db_pass
  db_user   = var.db_user
  namespace = "kong"

  # We can use autoscaling feature, but need to have HPA running on our cluster to scale this replicas.
  enable_autoscaling       = true
  autoscaling_min_replicas = 2
  autoscaling_max_replicas = 3

  # It is possible to set a definition about the resources, so you only need to declare the request and / or the limits as you need.
  resources = {
    requests = {
      cpu    = "150m"
      memory = "175Mi"
    }
  }
}

/*
Need to use postgreSQL Database connection as input
*/
variable db_host {}
variable db_name {}
variable db_user {}
variable db_pass {}

output uri_admin {
  description = "URI for admin service"
  value       = module.kong.uri_admin_service
}
output name {
  description = "Name of helm release for kong"
  value       = module.kong.name
}
output ingress_class {
  description = "Kong ingress class name"
  value       = module.kong.ingressclass
}
