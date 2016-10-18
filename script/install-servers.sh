#!/bin/bash

gcloud compute instance-templates create "server" --machine-type "f1-micro" --image-family "/coreos-cloud/coreos-stable" --boot-disk-size "10GB" --metadata-from-file startup-script=server-script
gcloud beta compute instance-groups managed create "nomad-eu" --region "europe-west1" --template "server" --size "3"
