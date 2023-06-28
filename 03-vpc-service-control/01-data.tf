locals {

############################## Change ME ##############################
  prefix             = "vpcsc1"
  tf_sa              = "gcp-sinprj-terraform@sinprj.iam.gserviceaccount.com"  ##create a service account for terraform in your org using script
  acx_access_policy  = "399093724144" # Default org access policy. ## you can find it using gcloud beta access-context-manager policies list  --organization=0123456789
  parent_folder_name = "demo"
  org_id             = "417554380252"  
######################################################################


  folder_id = data.google_active_folder.demo.name

  perimeter_name_a        = "sp_${local.prefix}_perimeter_a"
  perimeter_name_b        = "sp_${local.prefix}_perimeter_b"
  perimeter_name_c        = "sp_${local.prefix}_perimeter_c"
  a_project_id            = data.google_projects.a_project.projects[0].project_id
  a_project_number        = data.google_project.a_project.number
  b_project_id            = data.google_projects.b_project.projects[0].project_id
  b_project_number        = data.google_project.b_project.number
  c_project_id            = data.google_projects.c_project.projects[0].project_id
  c_project_number        = data.google_project.c_project.number
  svc_account_a_auth_view = "svc-acct-a-auth-view@${local.a_project_id}.iam.gserviceaccount.com"
}

data "google_active_folder" "demo" {
  display_name = local.parent_folder_name
  parent       = "organizations/${local.org_id}"
}

data "google_active_folder" "myfolder" {
  display_name = local.prefix
  parent       = local.folder_id
}


data "google_projects" "a_project" {
  filter = "parent.id:${split("/", data.google_active_folder.myfolder.name)[1]} labels.environment=a lifecycleState=ACTIVE"
}

data "google_project" "a_project" {
  project_id = local.a_project_id
}

data "google_projects" "b_project" {
  filter = "parent.id:${split("/", data.google_active_folder.myfolder.name)[1]} labels.environment=b lifecycleState=ACTIVE"
}

data "google_project" "b_project" {
  project_id = local.b_project_id
}

data "google_projects" "c_project" {
  filter = "parent.id:${split("/", data.google_active_folder.myfolder.name)[1]} labels.environment=c lifecycleState=ACTIVE"
}

data "google_project" "c_project" {
  project_id = local.c_project_id
}

