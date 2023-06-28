resource "google_compute_global_address" "hub_psc_all_api_central1_ip" {
  provider     = google-beta
  project      = local.a_project_id
  name         = "hub-psc-api-ip"
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = module.project_a_vpc.network_id
  address      = element(split("/", local.psc_ip_ranges["us-central1"][0].range), 0) #"10.200.5.0"
}

resource "google_compute_global_forwarding_rule" "hub_psc_fr_central1" {
  provider              = google-beta
  project               = local.a_project_id
  name                  = "pscapi"
  target                = "vpc-sc"
  network               = module.project_a_vpc.network_id
  ip_address            = google_compute_global_address.hub_psc_all_api_central1_ip.id
  load_balancing_scheme = ""
}
