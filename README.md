## KONG MODULE
This repo allow to use Helm with Kong Chart as Kong Ingress Controller or as just only an API Gateway on kubernetes.

### Api Kong Gateway Content
Kong Gateway is the world’s most popular open source API gateway, built for multi-cloud and hybrid, and optimized for microservices and distributed architectures

### Stable Version
| Name | Version |
|:----:|:-------:|
| Kong Module | 0.1.5 |

### Requirements
| Name | Version |
|:----:|:-------:|
| kubernetes | >= 1.16 |
| postgreSQL | >= 9.5 |
| terraform | >= 0.13 |

  - Another Ingress Controler (optional)

### Components
| Name | Version | URL |
|:----:|:-------:|:---:|
| Kong Chart | 1.14.1 | https://github.com/Kong/charts/releases/tag/kong-1.14.1 |
| Kong docker image | 2.2.1 | https://github.com/Kong/docker-kong/releases/tag/2.2.1 |
| Kong for Kubernetes | 0.10 | https://konghq.com/blog/kong-for-kubernetes-0-10-released-with-ingress-v1-resource-improved-ingress-class-handling-and-more/ |


#### Examples main.tf
##### Kong as API Gateway
```hcl
module "kong_apigateway" {
  # Using our module your can set a versions to deploy specific features
  source  = "bennu/kong/helm"
  version = "0.1.5"

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

  # It is possible to set a definition about the resources quotas of pods,
  # so you only need to declare the request and / or the limits as you need.
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

##### Custom kong.conf
```hcl
module "kong" {
  source  = "bennu/kong/helm"
  ...

  # we can configure customs values for kong.conf (https://github.com/Kong/kong/blob/master/kong.conf.default)
  # only need to pass a list of names and values using variable "extra_env_configs" as below.
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
  ...
}
```

### Module Variables
Some details about variables for this Kong module.

#### Inputs
| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| db_host | PostgreSQL database hostname | `string` | n/a | yes |
| db_name | PostgreSQL database name | `string` | n/a | yes |
| db_pass | PostgreSQL database password | `string` | n/a | yes |
| db_user | PostgreSQL database user | `string` | n/a | yes |
| admin_annotations | Annotations for the Kong admin service | `map` | `{}` | no |
| admin_ingress_annotations | Annotations for Kong admin ingress | `map` | `{}` | no |
| admin_ingress_hostname | Kong admin hostname | `string` | `"admin.local"` | no |
| admin_ingress_path | Kong admin path on Ingress | `string` | `"/"` | no |
| admin_service_type | Kong admin service type on Kubernetes | `string` | `"ClusterIP"` | no |
| autoscaling_cpu_average_usage | Cpu average usage for autoscaling | `number` | `70` | no |
| autoscaling_max_replicas | Number of maximum replicas of pods | `string` | `2` | no |
| autoscaling_mem_average_usage | Memory average usage for autoscaling | `number` | `75` | no |
| autoscaling_min_replicas | Number of minimum replicas of pods | `string` | `1` | no |
| bash_image | Bash docker image name for jobs | `string` | `"bash"` | no |
| bash_image_tag | Bash docker image tag for jobs | `number` | `5` | no |
| chart_extra_set_configs | Using a list of maps as `[{"name"="foo", "value"="bar"},]` to create dynamics blocks of 'set' to merge with values | `list` | `[]` | no |
| chart_name | Helm chart name for Kong | `string` | `"kong"` | no |
| chart_repository | Helm chart repository for Kong | `string` | `"https://charts.konghq.com"` | no |
| chart_version | Helm chart version for Kong | `string` | `"1.14.1"` | no |
| create_ingress_controller | Create an Kong Ingress Controller | `bool` | `false` | no |
| database_engine | Database engine for Kong | `string` | `"postgres"` | no |
| db_port | PostgreSQL database port | `string` | `"5432"` | no |
| enable_admin_ingress | Admin exposure using another Ingress Controller | `bool` | `false` | no |
| enable_admin_service | Enable Kong admin service | `bool` | `true` | no |
| enable_autoscaling | Define if autoscale option is enable for Kong's pods | `bool` | `false` | no |
| enable_proxy_https | Enable TLS on Kong proxy service | `bool` | `false` | no |
| enable_proxy_ingress | Proxy exposure using another Ingress Controller | `bool` | `false` | no |
| enable_proxy_service | Enable Kong proxy service | `bool` | `true` | no |
| extra_env_configs | Define a list of maps as `[{"name"="foo", "value"="bar"},]` to configure customs values for kong.conf | `list` | `[]` | no |
| ingress_controller_install_crds | Install CRDS for Kong ingress controller, ONLY if using HELM 2. | `bool` | `false` | no |
| kong_image | Kong docker image name | `string` | `"kong"` | no |
| kong_tag | Kong docker image tag | `string` | `"2.2.1-alpine"` | no |
| migrations_post_upgrade | Able to activate post upgrade containers | `bool` | `true` | no |
| migrations_pre_upgrade | Able to activate pre upgrade containers | `bool` | `true` | no |
| migrations_resources | Define the limits and/or requests for migrations containers | `map` | `{}` | no |
| name | Value for kong name in pods | `string` | `""` | no |
| namespace | Namespace where resources are deployed | `string` | `"default"` | no |
| proxy_annotations | Annotations for the Kong proxy service | `map` | `{}` | no |
| proxy_ingress_annotations | Annotations for proxy on another Ingress Controller | `map` | `{}` | no |
| proxy_ingress_hosts | Proxy Hosts on another Ingress Controller | `list` | <pre>[<br>  "api.local"<br>]</pre> | no |
| proxy_ingress_path | Proxy path on another Ingress Controller | `string` | `"/"` | no |
| proxy_service_type | Kong proxy service type on Kubernetes | `string` | `"ClusterIP"` | no |
| registry | Custom registry host for be used in all the containers | `string` | `""` | no |
| reg_cred | Registry secret credential | `list` | `[]` | no |
| replica_count | Number of Kong pod replicas if autoscaling is not enable | `string` | `1` | no |
| resources | Define the limits and/or requests on pod resources | `map` | `{}` | no |

#### Outputs
| Name | Description |
|:----:|:-----------:|
| ingressclass | Kong ingress class name |
| name | Name of helm release for kong |
| uri_admin_service | URI for internal kong admin service |