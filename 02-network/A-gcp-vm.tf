# resource "google_service_account" "svc_a" {
#   account_id   = "svc-acct-a"
#   display_name = "Service Account A"
#   project      = module.project_a_vpc.project_id
# }

resource "google_service_account" "svc_account" {
  for_each     = toset(local.myprojects)
  account_id   = "${var.prefix}-prj-vm-svc-acct"
  display_name = "Service Account for ${var.prefix} VMs"
  project      = each.value
}


module "project-iam-bindings" {
  version  = "~> 7.0"
  for_each = toset([for x in local.myprojects : "${var.prefix}-prj-vm-svc-acct@${x}.iam.gserviceaccount.com"])
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = local.myprojects
  mode     = "additive"

  bindings = {
    "roles/storage.admin" = [
      "serviceAccount:${each.value}",
    ]
    "roles/bigquery.jobUser" = [
      "serviceAccount:${each.value}",
    ]
    "roles/bigquery.dataOwner" = [
      "serviceAccount:${each.value}",
    ]
  }
  depends_on = [
    google_service_account.svc_account
  ]

}


######## VM in project A
data "google_compute_zones" "available" {
  project = local.a_project_id
  region  = module.project_a_vpc.subnets_regions[0]
}



resource "google_compute_instance" "compute_a" {
  name                      = "compute-a"
  project                   = local.a_project_id
  machine_type              = "e2-micro"
  zone                      = data.google_compute_zones.available.names[0]
  allow_stopping_for_update = true
  tags                      = ["direct-iap", ]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }
  network_interface {
    subnetwork = module.project_a_vpc.subnets_self_links[0]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.svc_account[local.a_project_id].email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    module.project_a_vpc
  ]
  resource_policies = [google_compute_resource_policy.stop_only_us_daily_usc1[local.a_project_id].self_link]
}

output "compute-a" {
  value = "gcloud compute ssh ${google_compute_instance.compute_a.name} --project ${google_compute_instance.compute_a.project} --zone ${google_compute_instance.compute_a.zone}"
}



resource "google_service_account" "service_account_a" {
  account_id   = "svc-acct-a-auth-view"
  display_name = "Service Account in project A for testing authorized views"
  project      = local.a_project_id
}

resource "google_service_account_iam_member" "svc_account_a_iam" {
  for_each           = toset(["roles/iam.serviceAccountUser", "roles/iam.serviceAccountTokenCreator"])
  service_account_id = google_service_account.service_account_a.name
  role               = each.value
  member             = "user:imrannayer@google.com"
}


resource "google_project_iam_member" "project_a" {
  project = local.a_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account_a.email}"
}


resource "google_bigquery_dataset_access" "access_b_c" {
  project = local.c_project_id

  dataset_id    = "mydsauth"
  role          = "READER"
  user_by_email = google_service_account.service_account_a.email
}


resource "google_compute_instance" "compute_a_auth_view" {
  name                      = "compute-a-auth-view"
  project                   = local.a_project_id
  machine_type              = "e2-micro"
  zone                      = data.google_compute_zones.available.names[0]
  allow_stopping_for_update = true
  tags                      = ["direct-iap", ]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }
  network_interface {
    subnetwork = module.project_a_vpc.subnets_self_links[0]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.service_account_a.email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    module.project_a_vpc
  ]
  resource_policies = [google_compute_resource_policy.stop_only_us_daily_usc1[local.a_project_id].self_link]
}

output "compute-a-auth-view" {
  value = "gcloud compute ssh ${google_compute_instance.compute_a_auth_view.name} --project ${google_compute_instance.compute_a_auth_view.project} --zone ${google_compute_instance.compute_a_auth_view.zone}"
}

######## VM in project B

data "google_compute_zones" "available_b" {
  project = local.b_project_id
  region  = module.project_b_vpc.subnets_regions[0]
}



resource "google_compute_instance" "compute_b" {
  name                      = "compute-b"
  project                   = local.b_project_id
  machine_type              = "e2-micro"
  zone                      = data.google_compute_zones.available_b.names[0]
  allow_stopping_for_update = true
  tags                      = ["direct-iap", ]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }
  network_interface {
    subnetwork = module.project_b_vpc.subnets_self_links[0]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = google_service_account.svc_account[local.b_project_id].email
    # email  = google_service_account.svc_b.email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    module.project_a_vpc
  ]
  resource_policies = [google_compute_resource_policy.stop_only_us_daily_usc1[local.b_project_id].self_link]
}

output "compute-b" {
  value = "gcloud compute ssh ${google_compute_instance.compute_b.name} --project ${google_compute_instance.compute_b.project} --zone ${google_compute_instance.compute_b.zone}"
}



######## VM in project C

data "google_compute_zones" "available_c" {
  project = local.c_project_id
  region  = module.project_c_vpc.subnets_regions[0]
}



resource "google_compute_instance" "compute_c" {
  name                      = "compute-c"
  project                   = local.c_project_id
  machine_type              = "e2-micro"
  zone                      = data.google_compute_zones.available_c.names[0]
  allow_stopping_for_update = true
  tags                      = ["direct-iap", ]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }
  network_interface {
    subnetwork = module.project_c_vpc.subnets_self_links[0]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.svc_account[local.c_project_id].email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    module.project_a_vpc
  ]
  resource_policies = [google_compute_resource_policy.stop_only_us_daily_usc1[local.c_project_id].self_link]
}

output "compute-c" {
  value = "gcloud compute ssh ${google_compute_instance.compute_c.name} --project ${google_compute_instance.compute_c.project} --zone ${google_compute_instance.compute_c.zone}"
}

