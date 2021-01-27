module kong_ingress_controller {
  source = "../../"

  db_host   = var.db_host
  db_name   = var.db_name
  db_pass   = var.db_pass
  db_user   = var.db_user
  namespace = "kong"

  # Using create_ingress_controller we can define if this module deploy Kong Ingress Controller
  create_ingress_controller = true
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
  value       = module.kong_ingress_controller.uri_admin_service
}
output name {
  description = "Name of helm release for kong"
  value       = module.kong_ingress_controller.name
}
output ingress_class {
  description = "Kong ingress class name"
  value       = module.kong_ingress_controller.ingressclass
}
