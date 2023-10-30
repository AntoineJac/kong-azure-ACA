variable "resource_group_name" {
  type    = string
}

variable "container_app_environment_id" {
  type = string
}

variable "container_registry_login_server" {
  type    = string
}

variable "environment_name" {
  type = string
}

variable "konnect_internal_cp_endpoint" {
  type    = string
}

variable "konnect_internal_telemetry_endpoint" {
  type    = string
}

variable "konnect_internal_tls_crt" {
  type    = string
}

variable "konnect_internal_tls_key" {
  type    = string
}

variable "kong_container_image_repo" {
  type    = string
}

variable "kong_container_image_tag" {
  type    = string
}

variable "kong_container_image_tag_traffic" {
  type    = string
}

variable "kong_container_max_replicas" {
  type    = number
}

variable "kong_container_nginx_worker_processes" {
  type    = number
}

variable "kong_container_cpu" {
  type    = number
}

variable "kong_container_memory" {
  type    = string
}
