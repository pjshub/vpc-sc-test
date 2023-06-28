resource "google_folder" "myfolder" {
  display_name = var.prefix
  parent       = "folders/${local.folder_id}"
}
## main.tf variables are defined in terraform.tfvars, varibales.tf & most importantly01-data.tf
module "project_factory_a" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "${var.prefix}-prj-a"
  random_project_id = true
  folder_id         = google_folder.myfolder.id
  org_id            = local.org_id
  billing_account   = local.billing_account
  activate_apis     = local.activate_apis
  labels            = merge(var.labels, { vpcsc = "yes", environment = "a" })

  # vpc_service_control_attach_enabled = true
  # vpc_service_control_perimeter_name = google_access_context_manager_service_perimeter.service_perimeter.name

  # depends_on = [
  #   google_access_context_manager_service_perimeter.service_perimeter,
  #   module.access_level_members,
  # ]
}

output "project_factory_a" {
  value = "project_id = ${module.project_factory_a.project_id} : project_number = ${module.project_factory_a.project_number}"
}

module "project_factory_b" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "${var.prefix}-prj-b"
  random_project_id = true
  folder_id         = google_folder.myfolder.id
  org_id            = local.org_id
  billing_account   = local.billing_account
  activate_apis     = local.activate_apis
  labels            = merge(var.labels, { vpcsc = "yes", environment = "b" })


  # vpc_service_control_attach_enabled = true
  # vpc_service_control_perimeter_name = google_access_context_manager_service_perimeter.service_perimeter.name

  # depends_on = [
  #   google_access_context_manager_service_perimeter.service_perimeter,
  #   module.access_level_members,
  # ]
}

output "project_factory_b" {
  value = "project_id = ${module.project_factory_b.project_id} : project_number = ${module.project_factory_b.project_number}"
}

module "project_factory_c" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "${var.prefix}-prj-c"
  random_project_id = true
  folder_id         = google_folder.myfolder.id
  org_id            = local.org_id
  billing_account   = local.billing_account
  activate_apis     = local.activate_apis
  labels            = merge(var.labels, { vpcsc = "yes", environment = "c" })


  # vpc_service_control_attach_enabled = true
  # vpc_service_control_perimeter_name = google_access_context_manager_service_perimeter.service_perimeter.name

  # depends_on = [
  #   google_access_context_manager_service_perimeter.service_perimeter,
  #   module.access_level_members,
  # ]
}

output "project_factory_c" {
  value = "project_id = ${module.project_factory_c.project_id} : project_number = ${module.project_factory_c.project_number}"
}


