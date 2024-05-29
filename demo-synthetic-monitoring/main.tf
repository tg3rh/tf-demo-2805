terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "3.0.0"
    }
  }
}

provider "grafana" {
  alias           = "sm"
  sm_access_token = var.grafana_auth
  sm_url          = "https://synthetic-monitoring-api-eu-west-2.grafana.net"
}

data "grafana_synthetic_monitoring_probes" "main" {
  provider   = grafana.sm
}


resource "grafana_synthetic_monitoring_check" "http" {
  provider = grafana.sm
  job     = "CHANGE ME"
  target  = "https://grafana.com - CHANGEME"
  enabled = true
  probes = [
    data.grafana_synthetic_monitoring_probes.main.probes.Atlanta,
  ]
  labels = {
    name = "CHANGEME"
  }
  settings {
    http {}
  }
}