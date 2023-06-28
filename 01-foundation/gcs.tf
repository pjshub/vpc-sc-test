resource "google_storage_bucket" "bucket_a" {
  name                        = "${var.prefix}-8899-a"
  project                     = module.project_factory_a.project_id
  location                    = "us"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    env = "project-a"
  }
  depends_on = [
    module.project_factory_a
  ]

  force_destroy = true
}

resource "google_storage_bucket_object" "cloud_a" {
  name   = "cloud_a.png"
  source = "cloud.png"
  bucket = google_storage_bucket.bucket_a.name
}

# resource "google_storage_bucket_object" "bootstrap_folders_a" {
#   for_each = toset(["config/", "software/", ])
#   name     = each.value
#   content  = "bootstrap folders"
#   bucket   = google_storage_bucket.bucket_a.name
# }


resource "google_storage_bucket" "bucket_b" {
  name                        = "${var.prefix}-8899-b"
  project                     = module.project_factory_b.project_id
  location                    = "us"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    env = "project-b"
  }
  depends_on = [
    module.project_factory_b
  ]

  force_destroy = true
}

resource "google_storage_bucket_object" "cloud_b" {
  name   = "cloud_b.png"
  source = "cloud.png"
  bucket = google_storage_bucket.bucket_b.name
}

# resource "google_storage_bucket_object" "bootstrap_folders_b" {
#   for_each = toset(["config/", "software/", ])
#   name     = each.value
#   content  = "bootstrap folders"
#   bucket   = google_storage_bucket.bucket_b.name
# }

resource "google_storage_bucket" "bucket_c" {
  name                        = "${var.prefix}-8899-c"
  project                     = module.project_factory_c.project_id
  location                    = "us"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    env = "project-c"
  }
  depends_on = [
    module.project_factory_c
  ]

  force_destroy = true
}

resource "google_storage_bucket_object" "cloud_c" {
  name   = "cloud_c.png"
  source = "cloud.png"
  bucket = google_storage_bucket.bucket_c.name
}

# resource "google_storage_bucket_object" "bootstrap_folders_c" {
#   for_each = toset(["config/", "software/", ])
#   name     = each.value
#   content  = "bootstrap folders"
#   bucket   = google_storage_bucket.bucket_c.name
# }


output "bucket_project_a" {
  value = "gsutil ls ${google_storage_bucket.bucket_a.url}"
}

output "bucket_project_b" {
  value = "gsutil ls ${google_storage_bucket.bucket_b.url}"
}

output "bucket_project_c" {
  value = "gsutil ls ${google_storage_bucket.bucket_c.url}"
}
