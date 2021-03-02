variable name {
  description = "Value for kong name in pods"
  type        = string
  default     = ""
}

variable namespace {
  description = "Namespace where resources are deployed"
  type        = string
  default     = "default"
}

variable chart_repository {
  description = "Helm chart repository for Kong"
  type        = string
  default     = "https://charts.konghq.com"
}

variable chart_name {
  description = "Helm chart name for Kong"
  type        = string
  default     = "kong"
}

variable chart_version {
  description = "Helm chart version for Kong"
  type        = string
  default     = "1.15.0"
}

variable chart_extra_set_configs {
  description = "Using a list of maps as `[{\"name\"=\"foo\", \"value\"=\"bar\"},]` to create dynamics blocks of 'set' to merge with values"
  type        = list
  default     = []
}

variable kong_image {
  description = "Kong docker image name"
  type        = string
  default     = "kong"
}

variable kong_tag {
  description = "Kong docker image tag"
  type        = string
  default     = "2.2.1-alpine"
}

variable enable_autoscaling {
  description = "Define if autoscale option is enable for Kong's pods"
  type        = bool
  default     = false
}

variable autoscaling_max_replicas {
  description = "Number of maximum replicas of pods"
  type        = string
  default     = 2
}

variable autoscaling_min_replicas {
  description = "Number of minimum replicas of pods"
  type        = string
  default     = 1
}

variable autoscaling_cpu_average_usage {
  description = "Cpu average usage for autoscaling"
  type        = number
  default     = 70
}

variable autoscaling_mem_average_usage {
  description = "Memory average usage for autoscaling"
  type        = number
  default     = 75
}

variable replica_count {
  description = "Number of Kong pod replicas if autoscaling is not enable"
  type        = string
  default     = 1
}

variable database_engine {
  description = "Database engine for Kong"
  type        = string
  default     = "postgres"
}

variable db_host {
  description = "PostgreSQL database hostname"
  type        = string
}

variable db_port {
  description = "PostgreSQL database port"
  type        = string
  default     = "5432"
}

variable db_name {
  description = "PostgreSQL database name"
  type        = string
}

variable db_pass {
  description = "PostgreSQL database password"
  type        = string
}

variable db_user {
  description = "PostgreSQL database user"
  type        = string
}

variable enable_proxy_service {
  description = "Enable Kong proxy service"
  type        = bool
  default     = true
}

variable enable_proxy_https {
  description = "Enable TLS on Kong proxy service"
  type        = bool
  default     = false
}

variable proxy_service_type {
  description = "Kong proxy service type on Kubernetes"
  type        = string
  default     = "ClusterIP"
}

variable proxy_annotations {
  description = "Annotations for the Kong proxy service"
  type        = map
  default     = {}
}

variable enable_proxy_ingress {
  description = "Proxy exposure using another Ingress Controller"
  type        = bool
  default     = false
}

variable proxy_ingress_host {
  description = "Proxy Host on another Ingress Controller"
  type        = string
  default     = "api.local"
}

variable proxy_ingress_path {
  description = "Proxy path on another Ingress Controller"
  type        = string
  default     = "/"
}

variable proxy_ingress_annotations {
  description = "Annotations for proxy on another Ingress Controller"
  type        = map
  default     = {}
}

variable enable_admin_service {
  description = "Enable Kong admin service"
  type        = bool
  default     = true
}

variable admin_service_type {
  description = "Kong admin service type on Kubernetes"
  type        = string
  default     = "ClusterIP"
}

variable admin_annotations {
  description = "Annotations for the Kong admin service"
  type        = map
  default     = {}
}

variable enable_admin_ingress {
  description = "Admin exposure using another Ingress Controller"
  type        = bool
  default     = false
}

variable admin_ingress_hostname {
  description = "Kong admin hostname"
  type        = string
  default     = "admin.local"
}

variable admin_ingress_path {
  description = "Kong admin path on Ingress"
  type        = string
  default     = "/"
}

variable admin_ingress_annotations {
  description = "Annotations for Kong admin ingress"
  type        = map
  default     = {}
}

variable create_ingress_controller {
  description = "Create an Kong Ingress Controller"
  type        = bool
  default     = false
}

variable ingress_controller_install_crds {
  description = "Install CRDS for Kong ingress controller, ONLY if using HELM 2."
  type        = bool
  default     = false
}

variable resources {
  description = "Define the limits and/or requests on pod resources"
  type        = map
  default     = {}
}

variable extra_env_configs {
  description = "Define a list of maps as `[{\"name\"=\"foo\", \"value\"=\"bar\"},]` to configure customs values for kong.conf"
  type        = list
  default     = []
}

variable bash_image {
  description = "Bash docker image name for jobs"
  type        = string
  default     = "bash"
}

variable bash_image_tag {
  description = "Bash docker image tag for jobs"
  type        = number
  default     = 5
}

variable registry {
  description = "Custom registry host for be used in all the containers"
  type        = string
  default     = ""
}

variable reg_cred {
  description = "Registry secret credential"
  type        = list
  default     = []
}

variable migrations_pre_upgrade {
  description = "Able to activate pre upgrade containers"
  type        = bool
  default     = true
}

variable migrations_post_upgrade {
  description = "Able to activate post upgrade containers"
  type        = bool
  default     = true
}

variable migrations_resources {
  description = "Define the limits and/or requests for migrations containers"
  type        = map
  default     = {}
}