# Devoxx 2016 - Going Global with Nomad & Google Cloud Platform

Demo setup for a federated Nomad cluster in Google Cloud Platform in EU, US
and AS (Asia) regions.

## Prerequisites

## gcloud

The latest _gcloud_ Comand Line Interface should be installed and the folowing
environment variables should be set:

```
GCLOUD_PROJECT=global-datacenter
GCLOUD_REGION=europe-west1
```

Authorization to manage the 'global-datacenter' (or your) project. See
 https://cloud.google.com/sdk/gcloud/reference/auth/ for details.

## Create a Nomad Cluster in EU region

### Create 3 Nomad server nodes in separate zones.

use
```
cd scripts/
./install-servers.sh
```

Or perform the steps manually:
```
cd scripts/
gcloud compute instances create nomad-eu-1 --zone europe-west1-b \
  --machine-type g1-small \
  --image-project coreos-cloud \
  --image-family coreos-stable \
  --metadata-from-file startup-script=server-script&
gcloud compute instances create nomad-eu-2 --zone europe-west1-c \
  --machine-type g1-small \
  --image-project coreos-cloud \
  --image-family coreos-stable \
  --metadata-from-file startup-script=server-script&
gcloud compute instances create nomad-eu-3 --zone europe-west1-d \
  --machine-type g1-small \
  --image-project coreos-cloud \
  --image-family coreos-stable \
  --metadata-from-file startup-script=server-script&
```

Wait for completion

```
watch -d gcloud compute instances list nomad-eu-{1,2,3}
```

### Bootstrap the cluster
Login to a Nomad server and forward some ports:

```
./ssh-nomad-eu
```

See server status:

```
nomad server-members
```

Join servers together:

```
nomad server-join nomad-eu-{1,2,3}
```

See server status:

```
nomad server-members
```

See client node status:

```
nomad node-status
nomad node-status -self
```

## Schedule our first job

Schedule nomad-ui as a system job on all Nomad servers:

```
cd /tmp/devoxx-2016/jobs
nomad plan nomad-ui.nomad
nomad run nomad-ui.nomad
```

See the results:

```
nomad status
nomad status nomad-ui
nomad status -verbose nomad-ui
nomad alloc-status _xxx_
```

Browse to http://localhost:3000/

## Create a Farm of worker nodes

use

```
cd scripts/
./install-clients.sh
```

The clients will automatically join the Nomad cluster

check with
```
nomad node-status
```

## Run Helloworld

```
nomad run helloworld.nomad
```

Lookup host and port

```
nomad status helloworld
nomad alloc-status _xxx_
```

Call helloworld

```
curl -s http://_ip_:_port_/hello
curl -s http://_ip_:_port_/env | jq .
```

## Add Service discovery

```
nomad run consul.nomad
```

See cluster:

```
consul members
```

Check the UI at http://localhost:8500/ui

# Add HTTP routing

```
nomad run fabio.nomad
```

Check the UI at http://localhost:9998/

Test routing:

```
curl -s -H 'Host: helloworld.gce.nauts.io' http://localhost:9999/hello
```

## Make helloworld available via Google Load balancer

Prerequisites:
1. http-fabio health check
2. firewall rule to let LB access fabio
3. allocated static (```global-dc```)
4. ```helloword.gce.nauts.io``` DNS entry points to static IP.

In GCP console:

1. go to Networking / Load Balancer
2. click 'create load balancer'
3. HTTP(S) load balancing / Start configuration
4. Enter name ```devoxx```
5. Backend Configuration / Create a Backend service
6. Enter name ```farm-backend```
7. New Backend ```farm-eu```
8. port number: ```9999```
9. Health check ```http-fabio```
10. Leave Host and Path rules as is.
11. Frontend configuration / select a static IP ```global-dc``` for HTTP port 80
12. Create

Select 'monitoring' on created LB and wait until backends are healthy.
Check helloworld:

```
curl -s http://helloworld.gce.nauts.io/hello
```

## Load balance across regions

Create cluster in ```us-central1``` region with zones ```a```, ```b``` and ```c```:

```
cd scripts/
./install-region us-central1 a b c
```

Add backend to load balancer.

Perform requests to helloworld from US and Asia to see them served by the US cluster.
Latency will be lower.
