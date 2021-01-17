#!/usr/bin/env bash

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Delete uninstalls the demo application and deletes              -"
# "-  the GKE cluster                                      -"
# "-                                                       -"
# "---------------------------------------------------------"

# Do not set errexit as it makes partial deletes impossible
set -o nounset # Exposes unset variables
set -o pipefail # Unveils hidden failures

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Tear down Terraform-managed resources and remove generated tfvars
cd "$ROOT/iac_gke_cluster" || exit;
terraform destroy -input=false -auto-approve
rm -f "$ROOT/iac_gke_cluster/terraform.tfvars"
