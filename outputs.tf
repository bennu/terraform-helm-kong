output ingressclass {
  description = "Kong ingress class name"
  value       = var.create_ingress_controller ? local.ingressclass : ""
}

output name {
  description = "Name of helm release for kong"
  value       = helm_release.kong.metadata.0.name
}

output uri_admin_service {
  description = "URI for internal kong admin service"
  value       = local.uri_admin_service
}