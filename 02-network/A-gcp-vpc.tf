################ VPC A

module "project_a_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = local.a_project_id
  network_name = "vpc-a"
  # mtu          = 1460

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
  ]
}

/******************************************
  Cloud Router * NAT VPC A
 *****************************************/

module "cloud_router_a" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0"

  name    = "${module.project_a_vpc.network_name}-${module.project_a_vpc.subnets_regions[0]}-cr"
  project = module.project_a_vpc.project_id
  region  = module.project_a_vpc.subnets_regions[0]
  network = module.project_a_vpc.network_self_link
  nats = [{
    name                               = "${module.project_a_vpc.network_name}-${module.project_a_vpc.subnets_regions[0]}-nat"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    min_ports_per_vm                   = 4096
    log_config = {
      "filter" = "ERRORS_ONLY"
    }
    },
  ]
}

/******************************************
  Private Service Access * VPC A
 *****************************************/

module "private-service-access-a" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "~> 14.0"

  project_id  = module.project_a_vpc.project_id
  vpc_network = module.project_a_vpc.network_name
  address     = "10.20.0.0"
  # ip_version    = var.service_access_ip_version
  # labels        = var.labels
  prefix_length = 16
  depends_on = [
    module.project_a_vpc
  ]
}

# /******************************************
#   GCP Cloud Router VPN * VPC A
#  *****************************************/

resource "google_compute_router" "vpn_router_hub" {
  name    = "${module.project_a_vpc.network_name}-${module.project_a_vpc.subnets_regions[0]}-vpn-cr"
  project = module.project_a_vpc.project_id
  region  = module.project_a_vpc.subnets_regions[0]
  network = module.project_a_vpc.network_self_link
  #ASNs are reserved by Azure: 8075, 8076, 12076 (public), 65515, 65517, 65518, 65519, 65520 (private). Avoid using it if connecting to Azure
  bgp {
    asn               = 65000
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    dynamic "advertised_ip_ranges" {
      for_each = toset(["199.36.153.4/30", "199.36.153.8/30", "10.200.5.0/32"])
      content {
        range = advertised_ip_ranges.value
        # description = advertised_ip_ranges.value.description
      }
    }
  }
}


################ VPC B

module "project_b_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = local.b_project_id
  network_name = "vpc-b"
  # mtu          = 1460

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
  ]
}


/******************************************
  Cloud Router * NAT VPC B
 *****************************************/

module "cloud_router_b" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0"

  name    = "${module.project_b_vpc.network_name}-${module.project_b_vpc.subnets_regions[0]}-cr"
  project = module.project_b_vpc.project_id
  region  = module.project_b_vpc.subnets_regions[0]
  network = module.project_b_vpc.network_self_link
  nats = [{
    name                               = "${module.project_b_vpc.network_name}-${module.project_b_vpc.subnets_regions[0]}-nat"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    min_ports_per_vm                   = 4096
    log_config = {
      "filter" = "ERRORS_ONLY"
    }
    },
  ]
}

################ VPC C

module "project_c_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = local.c_project_id
  network_name = "vpc-c"
  # mtu          = 1460

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
  ]
}

module "cloud_router_c" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0"

  name    = "${module.project_c_vpc.network_name}-${module.project_c_vpc.subnets_regions[0]}-cr"
  project = module.project_c_vpc.project_id
  region  = module.project_c_vpc.subnets_regions[0]
  network = module.project_c_vpc.network_self_link
  nats = [{
    name                               = "${module.project_c_vpc.network_name}-${module.project_c_vpc.subnets_regions[0]}-nat"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    min_ports_per_vm                   = 4096
    log_config = {
      "filter" = "ERRORS_ONLY"
    }
    },
  ]
}


