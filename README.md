## KONG MODULE
This repo allow to use Helm with Kong Chart as Kong Ingress Controller or as just only an API Gateway on kubernetes.

### Api Kong Gateway Content
Kong Gateway is the world’s most popular open source API gateway, built for multi-cloud and hybrid, and optimized for microservices and distributed architectures

### Requirements
  - Terraform - Version 0.13+
  - Kubernetes - Version 0.16+
  - PostgreSQL Database - Version 9.5+
  - Another Ingress Controler (optional)

### Components
  - Chart Kong - Version 1.9.1
    https://github.com/Kong/charts/tree/kong-1.9.1

#### Examples main.tf
```hcl
module "kong_apigateway" {
  source = "./"

  db_hos    = var.db_host
  db_name   = var.db_name
  db_pass   = var.db_pass
  db_user   = var.db_user
  namespace = "kong"

  enable_proxy_ingress      = true
  proxy_ingress_hosts       = ["prod.api.xyz.com"]
  proxy_ingress_annotations = { kubernetes.io/ingress.class: "nginx" }
}
```

```hcl
module "kong_ingresscontroller" {
  source = "./"

  db_host = var.db_host
  db_name = var.db_name
  db_pass = var.db_pass
  db_user = var.db_user

  create_ingress_controller = true
}

```
#### Module Variables
Some details about variables for this Kong module.

| Type | Key | Value | Descripcion |
|------|-----|-------|-------------|
| Required | db_host |  | PostgreSQL hostname |
| Required | db_name |  | Database name |
| Required | db_user |  | Database username |
| Required | db_pass |  | Database password |
| Optional | db_port | `5432` | Database port number|
| Optional | name | `""` | Module Kong name |
| Optional | namespace | `default` | Kong namespace |
| Optional | cpu_limit | `600m` | CPU limit in Kong deployment for DEV stage |
| Optional | cpu_request | `200m` | CPU request in Kong deployment for DEV stage |
| Optional | memory_limit_ | `500Mi` | Memory limit in Kong deployment for DEV stage |
| Optional | memory_request | `200Mi` | Memory request in Kong deployment for DEV stage |
| Optional | enable_autoscaling | `false` | Enable autoscaling using HPA |
| Optional | enable_proxy_ingress | `false` | Proxy exposure using another Ingress Controller |
| Optional | enable_admin_ingress | `false`| Admin exposure using another Ingress Controller |
| Optional | create_ingress_controller | `false` | Create an Kong Ingress Controller |
| Optional | ingress_controller_install_crds | `false`| Install CRDS for Kong ingress controller, ONLY if using HELM 2.|