# resource "google_service_account" "service_account_a" {
#   account_id   = "svc-acct-a"
#   display_name = "Service Account in project A"
#   project      = module.project_factory_a.project_id
# }


# resource "google_service_account_iam_member" "svc_account_a_iam" {
#   for_each           = toset(["roles/iam.serviceAccountUser", "roles/iam.serviceAccountTokenCreator"])
#   service_account_id = google_service_account.service_account_a.name
#   role               = each.value
#   member             = "user:imrannayer@google.com"
# }


# # resource "google_bigquery_dataset_access" "access_b_a" {
# #   project      = module.project_factory_b.project_id

# #   dataset_id    = google_bigquery_dataset.auth_ds_b.dataset_id
# #   role          = "READER"
# #   user_by_email = google_service_account.service_account_a.email
# # }

# resource "google_project_iam_member" "project_a" {
#   project = module.project_factory_a.project_id
#   role    = "roles/bigquery.jobUser"
#   member  = "serviceAccount:${google_service_account.service_account_a.email}"
# }


# resource "google_bigquery_dataset_access" "access_b_c" {
#   project = module.project_factory_c.project_id

#   dataset_id    = google_bigquery_dataset.auth_ds_c.dataset_id
#   role          = "READER"
#   user_by_email = google_service_account.service_account_a.email
# }
