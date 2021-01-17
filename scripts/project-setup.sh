#!/usr/bin/env bash

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Creates GCP Project                                  -"
# "-                                        -"
# "-                                                       -"
# "---------------------------------------------------------"

# Do not set errexit as it makes partial deletes impossible
set -o nounset # Exposes unset variables
set -o pipefail # Unveils hidden failures

export PROJECT_ID=udupay-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

export BUCKET_NAME=udupay-gcs

export REGION=europe-west2

gsutil mb \
    -p $PROJECT_ID \
    -l $REGION \
    -c "NEARLINE" \
    gs://$BUCKET_NAME
