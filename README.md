## KONG MODULE
This repo allow to use Helm with Kong Chart as Kong Ingress Controller or as just only an API Gateway on kubernetes.

### Api Kong Gateway Content
Kong Gateway is the world’s most popular open source API gateway, built for multi-cloud and hybrid, and optimized for microservices and distributed architectures

### Requirements
| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| Kubernetes | >= 1.16 |
| PostgreSQL | >= 9.5 |

  - Another Ingress Controler (optional)

### Components
| Name | Version | URL |
|------|---------|-----|
| Kong Chart  | >= 0.13 | https://github.com/Kong/charts/tree/kong-1.9.1 |

#### Examples main.tf
##### Kong as API Gateway
```hcl
module "kong_apigateway" {
  source  = "bennu/kong/helm"
  version = "0.0.6"

  db_host   = var.db_host
  db_name   = var.db_name
  db_pass   = var.db_pass
  db_user   = var.db_user
  namespace = "kong"

  enable_proxy_ingress      = true
  proxy_ingress_hosts       = ["prod.api.xyz.com"]
  proxy_ingress_annotations = { kubernetes.io/ingress.class: "nginx" }
}
```

##### Kong as Ingress Controller
```hcl
module "kong_ingresscontroller" {
  source  = "bennu/kong/helm"

  db_host = var.db_host
  db_name = var.db_name
  db_pass = var.db_pass
  db_user = var.db_user

  create_ingress_controller = true

  # It is possible to set a definition about the resources, so you only need to declare the request and / or the limits as you need.
  resources = {
    requests = {
      cpu    = "250m"
      memory = "275Mi"
    }
    limits = {
      cpu    = "750m"
      memory = "550Mi"
    }
  }
}
```
### Module Variables
Some details about variables for this Kong module.

#### Inputs
| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| admin_annotations | Annotations for the Kong admin service | `map` | `{}` | no |
| admin_ingress_annotations | Annotations for Kong admin ingress | `map` | `{}` | no |
| admin_ingress_hostname | Kong admin hostname | `string` | `"admin.local"` | no |
| admin_ingress_path | Kong admin path on Ingress | `string` | `"/"` | no |
| admin_service_type | Kong admin service type on Kubernetes | `string` | `"ClusterIP"` | no |
| autoscaling_cpu_average_usage | Cpu average usage for autoscaling | `number` | `70` | no |
| autoscaling_max_replicas | Number of maximum replicas of pods | `string` | `2` | no |
| autoscaling_mem_average_usage | Memory average usage for autoscaling | `number` | `75` | no |
| autoscaling_min_replicas | Number of minimum replicas of pods | `string` | `1` | no |
| chart_name | Helm chart name for Kong | `string` | `"kong"` | no |
| chart_repository | Helm chart repository for Kong | `string` | `"https://charts.konghq.com"` | no |
| chart_version | Helm chart version for Kong | `string` | `"1.9.1"` | no |
| create_ingress_controller | Create an Kong Ingress Controller | `bool` | `false` | no |
| database_engine | Database engine for Kong | `string` | `"postgres"` | no |
| db_host | PostgreSQL database hostname | `string` | n/a | yes |
| db_name | PostgreSQL database name | `string` | n/a | yes |
| db_pass | PostgreSQL database password | `string` | n/a | yes |
| db_port | PostgreSQL database port | `string` | `"5432"` | no |
| db_user | PostgreSQL database user | `string` | n/a | yes |
| enable_admin_ingress | Admin exposure using another Ingress Controller | `bool` | `false` | no |
| enable_admin_service | Enable Kong admin service | `bool` | `true` | no |
| enable_autoscaling | Define if autoscale option is enable for Kong's pods | `bool` | `false` | no |
| enable_proxy_https | Enable TLS on Kong proxy service | `bool` | `false` | no |
| enable_proxy_ingress | Proxy exposure using another Ingress Controller | `bool` | `false` | no |
| enable_proxy_service | Enable Kong proxy service | `bool` | `true` | no |
| ingress_controller_install_crds | Install CRDS for Kong ingress controller, ONLY if using HELM 2. | `bool` | `false` | no |
| kong_image | Kong docker image name | `string` | `"kong"` | no |
| kong_tag | Kong docker image tag | `string` | `"2.1.4"` | no |
| name | Value for kong name in pods | `string` | `""` | no |
| namespace | Namespace where resources are deployed | `string` | `"default"` | no |
| proxy_annotations | Annotations for the Kong proxy service | `map` | `{}` | no |
| proxy_ingress_annotations | Annotations for proxy on another Ingress Controller | `map` | `{}` | no |
| proxy_ingress_hosts | Proxy Hosts on another Ingress Controller | `list` | <pre>[<br>  "api.local"<br>]</pre> | no |
| proxy_ingress_path | Proxy path on another Ingress Controller | `string` | `"/"` | no |
| proxy_service_type | Kong proxy service type on Kubernetes | `string` | `"ClusterIP"` | no |
| replica_count | Number of Kong pod replicas if autoscaling is not enable | `string` | `1` | no |
| resources | Define the limits and/or requests on pod resources | `map` | `{}` | no |

#### Outputs
| Name | Description |
|:----:|:-----------:|
| ingressclass | Kong ingress class name |
| name | Name of helm release for kong |
| uri_admin_service | URI for internal kong admin service |
