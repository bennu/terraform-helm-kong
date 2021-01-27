module kong {
  source = "../../"

  db_host   = var.db_host
  db_name   = var.db_name
  db_pass   = var.db_pass
  db_user   = var.db_user
  namespace = "kong"

  create_ingress_controller = true

  # we can configure customs values for kong.conf(https://github.com/Kong/kong/blob/master/kong.conf.default)
  # only need to pass a list of names and values in variable "extra_env_configs" as below.
  extra_env_configs = [
    {
      "name"  = "nginx_http_client_header_buffer_size",
      "value" = "16k"
    },
    {
      "name"  = "nginx_http_large_client_header_buffers",
      "value" = "8 64k"
    },
    {
      "name"  = "mem_cache_size",
      "value" = "200m"
    }
  ]

  # also configuring resources values is a good practice to do.
  resources = {
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
    limits = {
      cpu    = "1"
      memory = "1Gi"
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
