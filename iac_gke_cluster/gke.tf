# Terraform to keep the state in Google Cloud Storage (GCS)
terraform {
  backend "gcs" {
    bucket      = "udupay-gcs"
    prefix      = "terraform/state"
    credentials = file(var.gcp_auth_file)
  }
}

# GKE Master cluster
resource "google_container_cluster" "primary" {
  # count below means -> create resource if destroy is set to false, or destroy it if it’s set to true.
  count                     = var.destroy == true ? 0 : 1
  name                      = "${var.project_id}-gke"
  location                  = var.region
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
  count      = var.destroy == true ? 0 : 1
  name       = "${google_container_cluster.primary.name}-nodpool"
  location   = var.region
  cluster    = google_container_cluster.primary[0].name
  version    = var.k8s_version
  node_count = var.min_node_count

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

    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }

    management {
      auto_upgrade = false
    }

    tags = ["gke-node", "${var.project_id}-gke"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

  }
}
