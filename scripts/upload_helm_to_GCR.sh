#!/bin/bash

# bash "strict-mode", fail immediately if there is a problem
set -euo pipefail

# Upload "helm builder" build step image to GCR
echo "----- Cloning Cloud Build Helm repo ------"
git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git
cd cloud-builders-community/helm
GOOGLE_CLOUD_PROJECT=cloudkite-interviews-297904
GCR_HELM=gcr.io/$GOOGLE_CLOUD_PROJECT/helm
docker build -t $GCR_HELM .
echo "----- Uploading "Helm Builder" build step image to GCR ------"
docker push $GCR_HELM
echo "----- "Helm Builder" build step image upload to GCR successful ------"