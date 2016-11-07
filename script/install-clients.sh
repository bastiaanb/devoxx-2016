#!/bin/bash -x

VERSION=$(date +%s)
gcloud compute instance-templates create "client-${VERSION}" \
  --machine-type "g1-small" \
  --image-project "coreos-cloud" \
  --image-family "coreos-stable" \
  --boot-disk-size "10GB" \
  --metadata-from-file startup-script=client-script

gcloud compute instance-groups managed create farm-eu --region europe-west1 --template client-${VERSION} --size 3

read

watch gcloud compute instance-groups managed list-instances farm-eu --region "europe-west1"
gcloud compute instance-groups managed list-instances farm-eu --region "europe-west1"
