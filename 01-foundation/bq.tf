resource "google_bigquery_dataset" "ds_a" {
  dataset_id    = "myds"
  friendly_name = "myds"
  description   = "This is a dataset in project A"
  location      = "US"
  project       = module.project_factory_a.project_id
  # default_table_expiration_ms = 3600000

  labels = {
    env = "project-a"
  }
  depends_on = [
    module.project_factory_a
  ]
}

resource "google_bigquery_table" "table_a" {
  project    = module.project_factory_a.project_id
  dataset_id = google_bigquery_dataset.ds_a.dataset_id
  table_id   = "mytable"

  labels = {
    env = "project-a"
  }
  deletion_protection = false
}
output "table_a" {
  value = "bq query --use_legacy_sql=false 'select * from `${google_bigquery_table.table_a.project}.${google_bigquery_table.table_a.dataset_id}.${google_bigquery_table.table_a.table_id}`;'"
}


### Auth DS

resource "google_bigquery_dataset" "auth_ds_a" {
  dataset_id    = "mydsauth"
  friendly_name = "mydsauth"
  description   = "This is an Authorized dataset in project A"
  location      = "US"
  project       = module.project_factory_a.project_id
  # default_table_expiration_ms = 3600000

  labels = {
    env = "project-a"
  }
  depends_on = [
    module.project_factory_a
  ]
}

resource "google_bigquery_dataset_access" "access_a_a" {
  dataset_id = google_bigquery_dataset.ds_a.dataset_id
  project    = google_bigquery_dataset.ds_a.project
  dataset {
    dataset {
      project_id = google_bigquery_dataset.auth_ds_a.project
      dataset_id = google_bigquery_dataset.auth_ds_a.dataset_id
    }
    target_types = ["VIEWS"]
  }
}
#########################

resource "google_bigquery_dataset" "ds_b" {
  dataset_id    = "myds"
  friendly_name = "myds"
  description   = "This is a dataset in project B"
  location      = "US"
  project       = module.project_factory_b.project_id
  # default_table_expiration_ms = 3600000

  labels = {
    env = "project-b"
  }
  depends_on = [
    module.project_factory_b
  ]
}

resource "google_bigquery_table" "table_b" {
  project    = module.project_factory_b.project_id
  dataset_id = google_bigquery_dataset.ds_b.dataset_id
  table_id   = "mytable"

  labels = {
    env = "project-b"
  }

  deletion_protection = false
}

output "table_b" {
  value = "bq query --use_legacy_sql=false 'select * from `${google_bigquery_table.table_b.project}.${google_bigquery_table.table_b.dataset_id}.${google_bigquery_table.table_b.table_id}`;'"
}

##  Auth DS
resource "google_bigquery_dataset" "auth_ds_b" {
  dataset_id    = "mydsauth"
  friendly_name = "mydsauth"
  description   = "This is an Authorized dataset in project B"
  location      = "US"
  project       = module.project_factory_b.project_id
  # default_table_expiration_ms = 3600000
  labels = {
    env = "project-b"
  }
  depends_on = [
    module.project_factory_b,
  ]
}

resource "google_bigquery_dataset_access" "access_b_b" {
  dataset_id = google_bigquery_dataset.ds_b.dataset_id
  project    = google_bigquery_dataset.ds_b.project
  dataset {
    dataset {
      project_id = google_bigquery_dataset.auth_ds_b.project
      dataset_id = google_bigquery_dataset.auth_ds_b.dataset_id
    }
    target_types = ["VIEWS"]
  }
}


resource "google_bigquery_table" "auth_view_b" {
  dataset_id    = google_bigquery_dataset.auth_ds_b.dataset_id
  friendly_name = google_bigquery_dataset.auth_ds_b.dataset_id
  table_id      = "myview"
  description   = "View on table ${module.project_factory_b.project_id}.${google_bigquery_dataset.ds_b.dataset_id}.${google_bigquery_table.table_b.table_id}"
  # labels              = each.value["labels"]
  project             = module.project_factory_b.project_id
  deletion_protection = false

  view {
    query          = <<EOF
        SELECT y, z FROM `${module.project_factory_b.project_id}.${google_bigquery_dataset.ds_b.dataset_id}.${google_bigquery_table.table_b.table_id}` ORDER BY y DESC
    EOF
    use_legacy_sql = false
  }
  depends_on = [
    google_bigquery_table.table_b,
    google_bigquery_job.job_b,
  ]

}

output "view_b_on_table_b" {
  value = "bq query --use_legacy_sql=false --project_id ${module.project_factory_a.project_id} 'select * from `${google_bigquery_table.auth_view_b.project}.${google_bigquery_table.auth_view_b.dataset_id}.${google_bigquery_table.auth_view_b.table_id}`;'"
}

#########################

resource "google_bigquery_dataset" "ds_c" {
  dataset_id    = "myds"
  friendly_name = "myds"
  description   = "This is a dataset in project C"
  location      = "US"
  project       = module.project_factory_c.project_id
  # default_table_expiration_ms = 3600000

  labels = {
    env = "project-c"
  }
  depends_on = [
    module.project_factory_c
  ]
}

resource "google_bigquery_table" "table_c" {
  project    = module.project_factory_c.project_id
  dataset_id = google_bigquery_dataset.ds_c.dataset_id
  table_id   = "mytable"

  labels = {
    env = "project-c"
  }
  deletion_protection = false
}

output "table_c" {
  value = "bq query --use_legacy_sql=false 'select * from `${google_bigquery_table.table_c.project}.${google_bigquery_table.table_c.dataset_id}.${google_bigquery_table.table_c.table_id}`;'"
}

##  Auth DS
resource "google_bigquery_dataset" "auth_ds_c" {
  dataset_id    = "mydsauth"
  friendly_name = "mydsauth"
  description   = "This is an Authorized dataset in project C"
  location      = "US"
  project       = module.project_factory_c.project_id
  # default_table_expiration_ms = 3600000

  labels = {
    env = "project-c"
  }
  depends_on = [
    module.project_factory_c
  ]
}

resource "google_bigquery_dataset_access" "access_c_on_b" {
  dataset_id = google_bigquery_dataset.auth_ds_b.dataset_id
  project    = google_bigquery_dataset.auth_ds_b.project
  dataset {
    dataset {
      project_id = google_bigquery_dataset.auth_ds_c.project
      dataset_id = google_bigquery_dataset.auth_ds_c.dataset_id
    }
    target_types = ["VIEWS"]
  }
}


resource "google_bigquery_table" "auth_view_c" {
  dataset_id          = google_bigquery_dataset.auth_ds_c.dataset_id
  friendly_name       = google_bigquery_dataset.auth_ds_c.dataset_id
  table_id            = "myview"
  description         = "View on View ${module.project_factory_b.project_id}.${google_bigquery_dataset.auth_ds_b.dataset_id}.${google_bigquery_table.auth_view_b.table_id}"
  project             = module.project_factory_c.project_id
  deletion_protection = false

  view {
    query          = <<EOF
        SELECT z FROM `${module.project_factory_b.project_id}.${google_bigquery_dataset.auth_ds_b.dataset_id}.${google_bigquery_table.auth_view_b.table_id}` ORDER BY z DESC
    EOF
    use_legacy_sql = false
  }
  depends_on = [
    google_bigquery_table.auth_view_b,
    google_bigquery_job.job_b,
  ]

}

output "view_c_on_view_b" {
  value = "bq query --use_legacy_sql=false --project_id ${module.project_factory_a.project_id} 'select * from `${google_bigquery_table.auth_view_c.project}.${google_bigquery_table.auth_view_c.dataset_id}.${google_bigquery_table.auth_view_c.table_id}`;'"
}


############ Insert data in tables

resource "random_string" "job" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_bigquery_job" "job_a" {
  project = module.project_factory_a.project_id
  job_id  = "job_query_a_${random_string.job.result}"

  labels = {
    env = "project-a"
  }

  query {

    query = "SELECT row_number()  OVER() x, round(100/row_number() OVER()) y, round(1000/row_number() OVER()) z   FROM `bigquery-public-data.austin_311.311_service_requests` LIMIT 10"

    destination_table {
      project_id = module.project_factory_a.project_id
      dataset_id = google_bigquery_table.table_a.dataset_id
      table_id   = google_bigquery_table.table_a.table_id
    }

    allow_large_results = true
    flatten_results     = true

    script_options {
      key_result_statement = "LAST"
    }
  }
  depends_on = [
    google_bigquery_table.table_a
  ]
}

resource "google_bigquery_job" "job_b" {
  project = module.project_factory_b.project_id
  job_id  = "job_query_b_${random_string.job.result}"

  labels = {
    env = "project-b"
  }

  query {

    query = "SELECT row_number()  OVER() x, round(100/row_number() OVER()) y, round(1000/row_number() OVER()) z   FROM `bigquery-public-data.austin_311.311_service_requests` LIMIT 10"

    destination_table {
      project_id = module.project_factory_b.project_id
      dataset_id = google_bigquery_table.table_b.dataset_id
      table_id   = google_bigquery_table.table_b.table_id
    }

    allow_large_results = true
    flatten_results     = true

    script_options {
      key_result_statement = "LAST"
    }
  }
  depends_on = [
    google_bigquery_table.table_b
  ]
}

resource "google_bigquery_job" "job_c" {
  project = module.project_factory_c.project_id
  job_id  = "job_query_c_${random_string.job.result}"

  labels = {
    env = "project-c"
  }

  query {

    query = "SELECT row_number()  OVER() x, round(100/row_number() OVER()) y, round(1000/row_number() OVER()) z   FROM `bigquery-public-data.austin_311.311_service_requests` LIMIT 10"

    destination_table {
      project_id = module.project_factory_c.project_id
      dataset_id = google_bigquery_table.table_c.dataset_id
      table_id   = google_bigquery_table.table_c.table_id
    }

    allow_large_results = true
    flatten_results     = true

    script_options {
      key_result_statement = "LAST"
    }
  }
  depends_on = [
    google_bigquery_table.table_c
  ]
}
