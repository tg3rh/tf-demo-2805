terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "3.0.0"
    }
  }
}

provider "grafana" {
  alias = "irmslo"

  url  = "https://tigerha.grafana.net/"
  auth = var.grafana_auth
}


resource "grafana_slo" "kong_gateway" {
  provider = grafana.irmslo
  name        = "CHANGE ME"
  description = "CHANGE ME"
  query {
    ratio {
      success_metric  = "kong_http_requests_total{cluster=\"home\",code!=\"5..\"}"
      total_metric    = "kong_http_requests_total{cluster=\"home\"}"
      group_by_labels = ["job", "instance"]
    }
    type = "ratio"
  }
  objectives {
    value  = 0.995
    window = "30d"
  }
  destination_datasource {
    uid = "grafanacloud-prom"
  }
  label {
    key   = "slo"
    value = "terraform"
  }
  alerting {
    fastburn {
      annotation {
        key   = "name"
        value = "SLO Burn Rate Very High"
      }
      annotation {
        key   = "description"
        value = "Error budget is burning too fast"
      }
      label {
        key   = "type"
        value = "slo"
      }
    }

    slowburn {
      annotation {
        key   = "name"
        value = "SLO Burn Rate High"
      }
      annotation {
        key   = "description"
        value = "Error budget is burning too fast"
      }
      label {
        key   = "type"
        value = "slo"
      }
    }
  }
}
