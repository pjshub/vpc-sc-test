variable "prefix" {
  description = "Prefix attached to resource names"
}

variable "labels" {
  description = "required labels. Keys and values can contain only lowercase letters, numeric characters, underscores, and dashes. All characters must use UTF-8 encoding, and international characters are allowed."
  default     = {}
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified"
  default     = "debian-10"
}

variable "source_image_project" {
  description = "Project where the source image comes from. The default project contains CentOS images."
  default     = "debian-cloud"
}

variable "whitelist_cidr" {
  description = "List of maps of External CIDR to whitelist"
  default     = []
}
