locals {
############################## Change ME ##############################

  tf_sa           = "gcp-sinprj-terraform@sinprj.iam.gserviceaccount.com"
  folder_id       = "1020720316407" # Demo folder under organization. If you dont have folder name "demo" under your org create it first
  org_id          = "417554380252"
  billing_account = "0189FA-E139FD-136A58"
########################################################################




  activate_apis = [
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "cloudkms.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "billingbudgets.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    #
    "accesscontextmanager.googleapis.com",
    "container.googleapis.com",
    "serviceusage.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicedirectory.googleapis.com",
  ]

  myprojects = [
    module.project_factory_a.project_id,
    module.project_factory_b.project_id,
    module.project_factory_c.project_id,
  ]
  a_project_id     = module.project_factory_a.project_id
  a_project_number = module.project_factory_a.project_number
  b_project_id     = module.project_factory_b.project_id
  b_project_number = module.project_factory_b.project_number
  c_project_id     = module.project_factory_c.project_id
  c_project_number = module.project_factory_a.project_number
}
