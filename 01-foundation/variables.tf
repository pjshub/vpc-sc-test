variable "prefix" {
  description = "Prefix attached to resource names"
}

variable "labels" {
  description = "required labels. Keys and values can contain only lowercase letters, numeric characters, underscores, and dashes. All characters must use UTF-8 encoding, and international characters are allowed."
  default     = {}
}
