####### Perimeter A around Project A

resource "google_access_context_manager_service_perimeter" "service_perimeter_a" {
  parent      = "accessPolicies/${local.acx_access_policy}"
  name        = "accessPolicies/${local.acx_access_policy}/servicePerimeters/${local.perimeter_name_a}"
  title       = local.perimeter_name_a
  description = "Test Service perimeter A"

  status {
    restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
    resources           = ["projects/${local.a_project_number}"]
    access_levels       = formatlist("accessPolicies/${local.acx_access_policy}/accessLevels/%s", module.access_level_members.name)

    egress_policies {
      egress_from {
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
      }
      egress_to {
        resources = [
          "projects/${local.b_project_number}",
          "projects/${local.c_project_number}",
        ]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.tables.getData"
          }
        }
      }
    }

  }

}


####### Perimeter B around Project B

resource "google_access_context_manager_service_perimeter" "service_perimeter_b" {
  parent      = "accessPolicies/${local.acx_access_policy}"
  name        = "accessPolicies/${local.acx_access_policy}/servicePerimeters/${local.perimeter_name_b}"
  title       = local.perimeter_name_b
  description = "Test Service perimeter B"

  status {
    restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
    resources           = ["projects/${local.b_project_number}"]
    access_levels       = formatlist("accessPolicies/${local.acx_access_policy}/accessLevels/%s", module.access_level_members.name)


    ingress_policies {

      ingress_from {
        # identity_type = "ANY_IDENTITY"
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
        sources {
          resource = "projects/${local.a_project_number}"
        }
      }

      ingress_to {
        resources = ["projects/${local.b_project_number}"]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.tables.getData"
          }
        }
      }

    }



    egress_policies {
      egress_from {
        # identity_type = "ANY_IDENTITY"
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
      }
      egress_to {
        resources = ["projects/${local.a_project_number}", ]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.jobs.create"
          }
        }
      }
    }

    egress_policies {
      egress_from {
        # identity_type = "ANY_IDENTITY"
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
      }
      egress_to {
        resources = ["projects/${local.c_project_number}", ]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.tables.getData"
          }
        }
      }
    }

  }

}



####### Perimeter C around Project C


resource "google_access_context_manager_service_perimeter" "service_perimeter_c" {
  parent      = "accessPolicies/${local.acx_access_policy}"
  name        = "accessPolicies/${local.acx_access_policy}/servicePerimeters/${local.perimeter_name_c}"
  title       = local.perimeter_name_c
  description = "Test Service perimeter C"

  status {
    restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
    resources           = ["projects/${local.c_project_number}"]
    access_levels       = formatlist("accessPolicies/${local.acx_access_policy}/accessLevels/%s", module.access_level_members.name)


    ingress_policies {

      ingress_from {
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
        sources {
          resource = "projects/${local.a_project_number}"
        }
      }

      ingress_to {
        resources = ["projects/${local.c_project_number}"]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.tables.getData"
          }
        }
      }

    }

    egress_policies {
      egress_from {
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
      }
      egress_to {
        resources = ["projects/${local.b_project_number}", ]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.tables.getData"
          }
        }
      }
    }


    egress_policies {
      egress_from {
        # identity_type = "ANY_IDENTITY"
        identities = ["serviceAccount:${local.svc_account_a_auth_view}"]
      }
      egress_to {
        resources = ["projects/${local.a_project_number}", ]
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.jobs.create"
          }
        }
      }
    }



  }

}

