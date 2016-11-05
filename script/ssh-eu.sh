#!/bin/bash -x

gcloud compute ssh \
  --ssh-flag="-L 4646:localhost:4646" \
  --ssh-flag="-L 8500:localhost:8500" \
  --ssh-flag="-L 9998:localhost:9998" \
  --ssh-flag="-L 3000:localhost:3000" \
  nomad-eu-3
