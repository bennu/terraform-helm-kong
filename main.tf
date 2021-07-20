resource "random_string" "kong_name" {
  count   = var.name == "" ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "helm_release" "kong" {
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
  dynamic "set" {
    for_each = var.chart_extra_set_configs
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
  dynamic "set" {
    for_each = var.extra_env_configs
    content {
      name  = format("env.%s", set.value["name"])
      value = set.value["value"]
    }
  }
  values = [
    yamlencode(
      {
        image = {
          repository  = local.kong_image
          tag         = var.kong_tag
          pullSecrets = var.reg_cred
        }
        waitImage = {
          repository = local.bash_image
          tag        = var.bash_image_tag
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
          ingressClass = local.ingressclass
          installCRDs  = var.ingress_controller_install_crds
          resources    = var.resources
          image = {
            repository = local.ingress_image
            tag        = var.ingress_image_tag
          }
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
            hostname    = var.proxy_ingress_host
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
        migrations = {
          preUpgrade  = var.migrations_pre_upgrade
          postUpgrade = var.migrations_post_upgrade
          resources   = var.migrations_resources
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
        priorityClassName = var.priority_class_name
        resources         = var.resources
      }
    )
  ]
}
