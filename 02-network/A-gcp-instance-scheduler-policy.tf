######## Custom Roles needed for project-number@compute-system.iam.gserviceaccount.com.
# locals {
#   myprojects = [
#     local.a_project_id,
#     local.b_project_id,
#     local.c_project_id,
#   ]
# }
resource "google_project_iam_custom_role" "instance_start_stop" {
  for_each    = toset(local.myprojects)
  project     = each.value
  role_id     = "Instance.Start.Stop"
  title       = "Compute Instance Scheduler role"
  description = "Grant Permission to Google managed service account for starting and stopping instance using scheduler"

  permissions = [
    "compute.instances.start",
    "compute.instances.stop",
  ]
}

data "google_project" "project" {
  for_each   = toset(local.myprojects)
  project_id = each.value
}

resource "google_project_iam_member" "compute_consumer" {
  for_each = toset(local.myprojects)
  project  = each.value
  role     = google_project_iam_custom_role.instance_start_stop[each.value].id
  member   = "serviceAccount:service-${data.google_project.project[each.value].number}@compute-system.iam.gserviceaccount.com"
}

######## Scheduler to stop instance

resource "google_compute_resource_policy" "stop_only_us_daily_usc1" {
  for_each    = toset(local.myprojects)
  name        = "usc1-stop-only"
  project     = each.value
  region      = "us-central1"
  description = "stop instances"
  instance_schedule_policy {
    vm_stop_schedule {
      schedule = "30 18 * * *"
    }
    time_zone = "US/Central"
  }
}

resource "google_compute_resource_policy" "stop_only_us_daily_use1" {
  for_each    = toset(local.myprojects)
  name        = "use1-stop-only"
  project     = each.value
  region      = "us-east1"
  description = "stop instances"
  instance_schedule_policy {
    vm_stop_schedule {
      schedule = "30 18 * * *"
    }
    time_zone = "US/Central"
  }
}



