locals {
  ingressclass = var.name == "" ? "kong" : var.name
  name         = var.name == "" ? format("kong-%s", random_string.kong_name.0.result) : var.name
  resources = {
    requests = {
      memory = var.memory_request
      cpu    = var.cpu_request
    }
    limits = {
      memory = var.memory_limit
      cpu    = var.cpu_limit
    }
  }
  uri_admin_service = format("http://%s-kong-admin.%s.svc:8001", helm_release.kong.metadata.0.name, helm_release.kong.metadata.0.namespace)
}