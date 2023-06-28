locals {
  rfc1918_cidr_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", ]
}

/******************************************
  Ranges for default firewall rules.
 *****************************************/

data "google_netblock_ip_ranges" "legacy_health_checkers" {
  range_type = "legacy-health-checkers"
}

data "google_netblock_ip_ranges" "health_checkers" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

module "net_firewall_a" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = module.project_a_vpc.project_id
  network                 = module.project_a_vpc.network_name
  ssh_source_ranges       = []
  http_source_ranges      = []
  https_source_ranges     = []
  internal_ranges_enabled = true
  internal_ranges         = local.rfc1918_cidr_ranges
  internal_allow = [
    {
      protocol = "all"
    },
  ]
  custom_rules = {
    allow-ssh-from-iap = {
      description          = "Allow SSH access from IAP tunnel"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
      sources              = []
      targets              = ["direct-iap"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [22]
        },
      ]
      extra_attributes = {}
    }
    allow-rdp-from-iap = {
      description          = "Allow RDP access from IAP tunnel"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
      sources              = []
      targets              = ["direct-iap"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [3389]
        },
        {
          protocol = "udp"
          ports    = [3389]
        },
      ]
      extra_attributes = {}
    }
    allow-lb-healthcheck = {
      description          = "Allow Load balancer health check to all backends"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)
      sources              = []
      targets              = []
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = []
        },
      ]
      extra_attributes = {}
    }
  }
}


################## VPC B

module "net_firewall_b" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = module.project_b_vpc.project_id
  network                 = module.project_b_vpc.network_name
  ssh_source_ranges       = []
  http_source_ranges      = []
  https_source_ranges     = []
  internal_ranges_enabled = true
  internal_ranges         = local.rfc1918_cidr_ranges
  internal_allow = [
    {
      protocol = "all"
    },
  ]
  custom_rules = {
    allow-ssh-from-iap = {
      description          = "Allow SSH access from IAP tunnel"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
      sources              = []
      targets              = ["direct-iap"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [22]
        },
      ]
      extra_attributes = {}
    }
    allow-rdp-from-iap = {
      description          = "Allow RDP access from IAP tunnel"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
      sources              = []
      targets              = ["direct-iap"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [3389]
        },
        {
          protocol = "udp"
          ports    = [3389]
        },
      ]
      extra_attributes = {}
    }
    allow-lb-healthcheck = {
      description          = "Allow Load balancer health check to all backends"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)
      sources              = []
      targets              = []
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = []
        },
      ]
      extra_attributes = {}
    }
  }
}

################## VPC C

module "net_firewall_c" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = module.project_c_vpc.project_id
  network                 = module.project_c_vpc.network_name
  ssh_source_ranges       = []
  http_source_ranges      = []
  https_source_ranges     = []
  internal_ranges_enabled = true
  internal_ranges         = local.rfc1918_cidr_ranges
  internal_allow = [
    {
      protocol = "all"
    },
  ]
  custom_rules = {
    allow-ssh-from-iap = {
      description          = "Allow SSH access from IAP tunnel"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
      sources              = []
      targets              = ["direct-iap"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [22]
        },
      ]
      extra_attributes = {}
    }
    allow-rdp-from-iap = {
      description          = "Allow RDP access from IAP tunnel"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
      sources              = []
      targets              = ["direct-iap"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [3389]
        },
        {
          protocol = "udp"
          ports    = [3389]
        },
      ]
      extra_attributes = {}
    }
    allow-lb-healthcheck = {
      description          = "Allow Load balancer health check to all backends"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)
      sources              = []
      targets              = []
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = []
        },
      ]
      extra_attributes = {}
    }
  }
}
