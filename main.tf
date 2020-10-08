resource random_string kong_name {
  count   = var.name == "" ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource helm_release kong {
  name       = local.name
  atomic     = true
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace
  skip_crds  = var.create_ingress_controller ? false : true
  set_sensitive {
    name  = "env.pg_password"
    value = var.db_pass
  }
  values = [
    yamlencode(
      {
        image = {
          repository = var.kong_image
          tag        = var.kong_tag
        }
        env = {
          database    = var.database_engine
          pg_database = var.db_name
          pg_host     = var.db_host
          pg_user     = var.db_user
          pg_port     = var.db_port
        }
        ingressController = {
          enabled      = var.create_ingress_controller
          installCRDs  = var.ingress_controller_install_crds
          ingressClass = local.ingressclass
        }
        proxy = {
          enabled     = var.enable_proxy_service
          type        = var.proxy_service_type
          annotations = var.proxy_annotations
          tls = {
            enabled = var.enable_proxy_https
          }
          ingress = {
            enabled     = var.enable_proxy_ingress
            annotations = var.proxy_ingress_annotations
            hosts       = var.proxy_ingress_hosts
            path        = var.proxy_ingress_path
          }
        }
        admin = {
          enabled     = var.enable_admin_service
          type        = var.admin_service_type
          annotations = var.admin_annotations
          http = {
            enabled = true
          }
          ingress = {
            enabled     = var.enable_admin_ingress
            annotations = var.admin_ingress_annotations
            hostname    = var.admin_ingress_hostname
            path        = var.admin_ingress_path
          }
        }
        replicaCount = var.enable_autoscaling ? var.autoscaling_min_replicas : var.replica_count
        autoscaling = {
          enabled     = var.enable_autoscaling
          minReplicas = var.autoscaling_min_replicas
          maxReplicas = var.autoscaling_max_replicas
          metrics = [
            {
              type = "Resource"
              resource = {
                name = "cpu"
                target = {
                  type               = "Utilization"
                  averageUtilization = var.autoscaling_cpu_average_usage
                }
              }
            },
            {
              type = "Resource"
              resource = {
                name = "memory"
                target = {
                  type               = "Utilization"
                  averageUtilization = var.autoscaling_mem_average_usage
                }
              }
            }
          ]
        }
        affinity = {
          podAntiAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = [
              {
                labelSelector = {
                  matchLabels = {
                    "app.kubernetes.io/component" = "app"
                    "app.kubernetes.io/instance"  = local.name
                    "app.kubernetes.io/name"      = "kong"
                  }
                }
                topologyKey = "kubernetes.io/hostname"
              }
            ]
          }
        }
        priorityClassName = "system-cluster-critical"
        resources         = local.resources
      }
    )
  ]
}