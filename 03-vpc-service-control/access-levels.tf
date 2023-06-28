
module "access_level_members" {
  source = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy = local.acx_access_policy
  name   = "terraform_members"
  members = [
    "serviceAccount:${local.tf_sa}",
  ]
}

module "access_level_members_restricted" {
  source = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy = local.acx_access_policy
  name   = "restricted_members"
  members = [
    "user:imrannayer@google.com"
  ]
}
