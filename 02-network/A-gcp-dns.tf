## DNS Private zone if default route is not set to Internet gateway

/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/

# module "hub_private_googleapis" {
#   source      = "terraform-google-modules/cloud-dns/google"
#   version     = "~> 4.0"
#   project_id  = local.a_project_id
#   type        = "private"
#   name        = "dz-hub-googleapis"
#   domain      = "googleapis.com."
#   description = "Private DNS zone to configure googleapis.com"

#   private_visibility_config_networks = [
#     module.hub_vpc.network_self_link
#   ]

#   recordsets = [
#     {
#       name    = "*"
#       type    = "CNAME"
#       ttl     = 60
#       records = ["private.googleapis.com."]
#     },
#     {
#       name    = "private"
#       type    = "A"
#       ttl     = 60
#       records = local.private_googleapis_ip
#     },
#     {
#       name    = "restricted"
#       type    = "A"
#       ttl     = 60
#       records = local.restricted_googleapis_ip
#     },
#   ]
# }

/******************************************
  Private GCR DNS Zone & records.
 *****************************************/

module "a_private_gcr" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.0"
  project_id  = local.a_project_id
  type        = "private"
  name        = "dz-gcr"
  domain      = "gcr.io."
  description = "Restricted DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    module.project_a_vpc.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 60
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 60
      records = local.restricted_googleapis_ip
    },
  ]
}

/**********************************************
  DNS policy for inbound DNS request
 *********************************************/

resource "google_dns_policy" "default_policy" {
  project                   = local.a_project_id
  name                      = "inbound-dns-policy"
  description               = "GCP Inbound DNS"
  enable_inbound_forwarding = true
  enable_logging            = false
  networks {
    network_url = module.project_a_vpc.network_self_link
  }
}

# output "zzz_find_dns_fw_ip_address" {
#   value = "Use this command to find dns resolver IP and add it to other cloud or on-prem forwarder. gcloud compute addresses list --filter='purpose:DNS_RESOLVER' --project ${local.a_project_id}"
# }


# /**********************************************
#   DNS Response policy for DNS request
#  *********************************************/

resource "google_dns_response_policy" "response_policy_psa" {
  provider = google-beta
  project  = local.a_project_id

  response_policy_name = "psa-response-policy"

  networks {
    network_url = module.project_a_vpc.network_id
  }
}

resource "google_dns_response_policy_rule" "psa_response_policy_rule" {
  provider = google-beta
  project  = local.a_project_id

  response_policy = google_dns_response_policy.response_policy_psa.response_policy_name
  rule_name       = "psa-rule"
  dns_name        = "*.googleapis.com."

  local_data {
    local_datas {
      name    = "*.googleapis.com."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["restricted.googleapis.com."]
    }
  }
}

resource "google_dns_response_policy_rule" "psa_private_response_policy_rule" {
  provider = google-beta
  project  = local.a_project_id

  response_policy = google_dns_response_policy.response_policy_psa.response_policy_name
  rule_name       = "psa-private-rule"
  dns_name        = "restricted.googleapis.com."

  local_data {
    local_datas {
      name    = "restricted.googleapis.com."
      type    = "A"
      ttl     = 300
      rrdatas = [google_compute_global_address.hub_psc_all_api_central1_ip.address]
    }
  }

}

# resource "google_dns_response_policy_rule" "psa_response_policy_bq_exempt_rule" {
#   provider = google-beta
#   project  = local.a_project_id

#   response_policy = google_dns_response_policy.response_policy_psa.response_policy_name
#   rule_name       = "psa-rule-bq-bypass"
#   dns_name        = "bigquery.googleapis.com."
#   behavior        = "bypassResponsePolicy"
# }
