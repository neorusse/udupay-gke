# Terraform to keep the state in Google Cloud Storage (GCS)
terraform {
  backend "gcs" {
    bucket      = "udupay-gcs"
    prefix      = "terraform/state"
    access_token  = ""
  }
}

# GKE Master cluster
resource "google_container_cluster" "primary" {
  name                      = var.cluster_name
  #location                  = var.region
  location                  = var.zone
  min_master_version        = var.k8s_version
  remove_default_node_pool  = true
  initial_node_count        = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

}

# Separately Managed Worker Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = var.cluster_name
  #location   = var.region
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  version    = var.k8s_version
  node_count = var.min_node_count

  # node_locations = [
  #   "europe-west2-a",
  #   "europe-west2-b"
  # ]

  # Enables logging & monitoring
  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    labels = {
      env = var.project_id
    }

    tags = ["gke-node", "${var.project_id}-gke"]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_upgrade = false
  }

}
