#!/usr/bin/env bash

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Helper script to generate terraform variables        -"
# "-  file based on glcoud defaults.                       -"
# "-                                                       -"
# "---------------------------------------------------------"

# Strict Mode - Stop immediately if something goes wrong
set -euo pipefail

echo "Generating terraform.tfvars file..."

# Save the root dir of the project to ROOT variable
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# This script should be run from directory that contains the terraform directory.
# The purpose is to populate defaults for subsequent terraform commands.

# git is required
command -v git >/dev/null 2>&1 || { \
 echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }

# glcoud is required
command -v gcloud >/dev/null 2>&1 || { \
 echo >&2 "I require gcloud but it's not installed.  Aborting."; exit 1; }


# gcloud config holds values related to your environment. If you already
# defined a default region we will retrieve it and use it
REGION="$(gcloud config get-value compute/region)"
if [[ -z "${REGION}" ]]; then
    echo "https://cloud.google.com/compute/docs/regions-zones/changing-default-zone-region" 1>&2
    echo "gcloud cli must be configured with a default region." 1>&2
    echo "run 'gcloud config set compute/region REGION'." 1>&2
    echo "replace 'REGION' with the region name like europe-west2." 1>&2
    exit 1;
fi

# gcloud config holds values related to your environment. If you already
# defined a default zone we will retrieve it and use it
ZONE="$(gcloud config get-value compute/zone)"
if [[ -z "${ZONE}" ]]; then
    echo "https://cloud.google.com/compute/docs/regions-zones/changing-default-zone-region" 1>&2
    echo "gcloud cli must be configured with a default zone." 1>&2
    echo "run 'gcloud config set compute/zone ZONE'." 1>&2
    echo "replace 'ZONE' with the zone name like europe-west2-a." 1>&2
    exit 1;
fi

# gcloud config holds values related to your environment. If you already
# defined a default project we will retrieve it and use it
PROJECT="$(gcloud config get-value core/project)"
if [[ -z "${PROJECT}" ]]; then
    echo "gcloud cli must be configured with a default project." 1>&2
    echo "run 'gcloud config set core/project PROJECT'." 1>&2
    echo "replace 'PROJECT' with the project name." 1>&2
    exit 1;
fi


# Use git to find the top-level directory and confirm
# by looking for the 'terraform' directory
PROJECT_DIR="$(git rev-parse --show-toplevel)"

if [[ -d "$ROOT/iac_gke_cluster" ]]; then
	PROJECT_DIR="$(pwd)"
fi

if [[ -z "${PROJECT_DIR}" ]]; then
    echo "Could not identify project base directory." 1>&2
    echo "Please re-run from a project directory and ensure" 1>&2
    echo "the .git directory exists." 1>&2
    exit 1;
fi


(

cd "${PROJECT_DIR}"

TFVARS_FILE="$ROOT/iac_gke_cluster/terraform.tfvars"

# We don't want to overwrite a pre-existing tfvars file
if [[ -f "${TFVARS_FILE}" ]]
then
    echo "${TFVARS_FILE} already exists." 1>&2
    echo "Please remove or rename before regenerating." 1>&2
    exit 1;
else

# Write out all the values we gathered into a tfvars file so you don't have to enter the values manually
# NB: How to add service account key or how to authenticate without the use of service account key?
cat <<EOF > "${TFVARS_FILE}"
  project_id="${PROJECT}"
  region="${REGION}"
  zone="${ZONE}"
EOF
fi

)
