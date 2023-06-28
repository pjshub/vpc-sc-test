locals {

############################## Change ME ##############################
  tf_sa              = "gcp-sinprj-terraform@sinprj.iam.gserviceaccount.com"
  org_id             = "417554380252"
  billing_account    = "0189FA-E139FD-136A58"
  parent_folder_name = "demo" ### Parent folder under your org
  folder_id          = data.google_active_folder.demo.name
########################################################################

  private_googleapis_ip    = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
  restricted_googleapis_ip = ["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]
  psc_ip_ranges = {
    "us-central1" = [
      {
        range       = "10.200.5.0/32"
        description = "US central private service connect IP 1"
      }
    ]
  }

  a_project_id     = data.google_projects.a_project.projects[0].project_id
  a_project_number = data.google_project.a_project.number
  b_project_id     = data.google_projects.b_project.projects[0].project_id
  b_project_number = data.google_project.b_project.number
  c_project_id     = data.google_projects.c_project.projects[0].project_id
  c_project_number = data.google_project.c_project.number
  myprojects = [
    local.a_project_id,
    local.b_project_id,
    local.c_project_id,
  ]


}

data "google_compute_image" "my_image" {
  family  = var.source_image_family
  project = var.source_image_project
}

data "google_active_folder" "demo" {
  display_name = local.parent_folder_name
  parent       = "organizations/${local.org_id}"
}

data "google_active_folder" "myfolder" {
  display_name = var.prefix
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

