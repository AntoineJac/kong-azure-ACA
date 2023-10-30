resource "azurerm_container_app" "konnect-internal-dp" {
  name     = "konnect-internal-dp-${var.environment_name}"
  resource_group_name = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode = "Multiple"

  tags = {
    env = var.environment_name
    role = "internal"
  }

  # registry {
  #   server = srp.azure.com
  # }

  secret {
    name = "tls-crt"
    value = var.konnect_internal_tls_crt
  }

  secret {
    name = "tls-key"
    value = var.konnect_internal_tls_key
  }

  ingress {
    external_enabled = true
    transport = "auto"
    allow_insecure_connections = true
    # custom_domain {
    #   name = "konnect-internal-dp-${var.environment_name}"
    #   certificate_binding_type = "Disabled"
    #   certificate_id = ""
    # }
    target_port = 8000
    traffic_weight {
      latest_revision = false
      percentage = 100
      revision_suffix = "version-${replace(var.kong_container_image_tag_traffic, ".", "-")}"
    }
  }

  template {
    revision_suffix = "version-${replace(var.kong_container_image_tag, ".", "-")}"
    min_replicas = 1
    max_replicas = var.kong_container_max_replicas

    custom_scale_rule {
      name = "auto-scale-rule"
      # pollingInterval = 300
      custom_rule_type = "cpu"
      metadata = {
        type = "Utilization"
        value = 80
      }
    }

    container {
      name = "konnect-proxy"
      image = "${var.container_registry_login_server}/${var.kong_container_image_repo}:${var.kong_container_image_tag}"
      cpu = var.kong_container_cpu
      memory = var.kong_container_memory
      command = []

      liveness_probe {
        transport = "HTTP"
        path = "/status"
        port = 8100
        initial_delay = 5
        interval_seconds = 10
        failure_count_threshold = 3
      }
      readiness_probe {
        transport = "HTTP"
        path = "/status"
        port = 8100
        interval_seconds = 10
        success_count_threshold = 1
        failure_count_threshold = 3
      }
    
      env {
        name = "KONG_ROLE"
        value = "data_plane"
      }
      env {
        name = "KONG_VITALS"
        value = "off"
      }
      env {
        name = "KONG_DATABASE"
        value = "off"
      }
      env {
        name = "KONG_NGINX_WORKER_PROCESSES"
        value = var.kong_container_nginx_worker_processes
      }
      env {
        name = "KONG_CLUSTER_MTLS"
        value = "pki"
      }
      env {
        name = "KONG_CLUSTER_CONTROL_PLANE"
        value = "${var.konnect_internal_cp_endpoint}:443"
      }
      env {
        name = "KONG_CLUSTER_SERVER_NAME"
        value = var.konnect_internal_cp_endpoint
      }
      env {
        name = "KONG_CLUSTER_TELEMETRY_ENDPOINT"
        value = "${var.konnect_internal_telemetry_endpoint}:443"
      }
      env {
        name = "KONG_CLUSTER_TELEMETRY_SERVER_NAME"
        value = var.konnect_internal_telemetry_endpoint
      }
      env {
        name = "KONG_CLUSTER_CERT"
        secret_name = "tls-crt"
      }
      env {
        name = "KONG_CLUSTER_CERT_KEY"
        secret_name = "tls-key"
      }
      env {
        name = "KONG_LUA_SSL_TRUSTED_CERTIFICATE"
        value = "system"
      }
      env {
        name = "KONG_KONNECT_MODE"
        value = "on"
      }
      env {
        name = "KONG_STATUS_LISTEN"
        value = "0.0.0.0:8100"
      }
      env {
        name = "KONG_REAL_IP_HEADER"
        value = "x-forwarded-for"
      }
      env {
        name = "KONG_TRUSTED_IPS"
        value = "0.0.0.0/0,::/0"
      }
    }
  }
}

