module "kong_apigateway" {
  source = "../../"

  db_host = var.db_host
  db_name = var.db_name
  db_pass = var.db_pass
  db_user = var.db_user

  # We can use another namespace to deploy all components, only need to secure that is exists.
  namespace = "kong"

  # When enable_proxy_ingress is true we need to use another ingress controller to expose our service
  enable_proxy_ingress = true
  proxy_ingress_host   = "prod.api.domain.com"
  # Here we can use annotations to define things like what ingress.class can use, ex. nginx.
  proxy_ingress_annotations = { kubernetes.io / ingress.class : "nginx" }
}

/*
Need to use postgreSQL Database connection as input
*/
variable db_host {}
variable db_name {}
variable db_user {}
variable db_pass {}
