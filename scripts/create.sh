#!/usr/bin/env bash

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Creates cluster and deploys demo application         -"
# "-                                                       -"
# "---------------------------------------------------------"
set -o errexit    # Used to exit upon error, avoiding cascading errors
set -o nounset    # Exposes unset variables
set -o pipefail   # Unveils hidden failures

echo "Setting ROOT dir variable..."
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Generate the variables to be used by Terraform
source "$ROOT/scripts/generate-tfvars.sh"

echo "Terraform tfvars file successfully created"

echo "Enabling APIs..."
# Enable required GCP APIs
gcloud services enable container.googleapis.com compute.googleapis.com cloudbuild.googleapis.com

echo "APIs now enabled"

# Initialize and run Terraform
(cd "$ROOT/iac_gke_cluster"; terraform init -input=false)
(cd "$ROOT/iac_gke_cluster"; terraform apply -input=false -auto-approve)
