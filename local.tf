locals {
  ingressclass      = var.name == "" ? "kong" : var.name
  name              = var.name == "" ? format("kong-%s", random_string.kong_name.0.result) : var.name
  uri_admin_service = format("http://%s-kong-admin.%s.svc:8001", helm_release.kong.metadata.0.name, helm_release.kong.metadata.0.namespace)
}
