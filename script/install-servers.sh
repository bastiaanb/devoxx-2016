#!/bin/bash -x

gcloud compute instances create nomad-eu-1 --zone europe-west1-b \
  --machine-type g1-small \
  --boot-disk-size 10GB \
  --image-project coreos-cloud \
  --image-family coreos-stable \
  --metadata-from-file startup-script=server-script&
gcloud compute instances create nomad-eu-2 --zone europe-west1-c \
  --machine-type g1-small \
  --boot-disk-size 10GB \
  --image-project coreos-cloud \
  --image-family coreos-stable \
  --metadata-from-file startup-script=server-script&
gcloud compute instances create nomad-eu-3 --zone europe-west1-d \
  --machine-type g1-small \
  --boot-disk-size 10GB \
  --image-project coreos-cloud \
  --image-family coreos-stable \
  --metadata-from-file startup-script=server-script&

read

watch -d gcloud compute instances list nomad-eu-{1,2,3}

gcloud compute instances list nomad-eu-{1,2,3}
