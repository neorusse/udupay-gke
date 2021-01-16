variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "gcp_auth_file" {
  description = "gcp_auth_file"
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "preemptible" {
  type    = bool
  default = true
}

variable "billing_account_id" {
  type    = string
  default = ""
}

variable "k8s_version" {
  type    = string
  default = "1.17.12-gke.1501"
}

variable "destroy" {
  type    = bool
  default = true
}
