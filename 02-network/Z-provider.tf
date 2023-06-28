/******************************************
  Provider credential configuration
 *****************************************/
provider "google" {
  impersonate_service_account = local.tf_sa
}

provider "google-beta" {
  impersonate_service_account = local.tf_sa
}