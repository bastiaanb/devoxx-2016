job "consul" {
  region = "eu"
  datacenters = [
    "europe-west1-b","europe-west1-c","europe-west1-d",
    "us-central1-a","us-central1-b","us-central1-c","us-central1-f",
    "asia-east1-a","asia-east1-b","asia-east1-c"
  ]
  type = "system"
  update {
    stagger = "15s"
    max_parallel = 1
  }

  group "consul-server" {
    constraint {
      attribute = "${node.class}"
      value = "system"
    }

    # Nomad 0.5 feature: keep data around.
    ephemeral_disk {
        sticky = true
        size = 150
    }

    task "consul-agent" {
      driver = "docker"
      config {
        image = "consul:0.7.0"
        network_mode="host"
        command = "agent"
        args = ["-server",
                "-node=${node.unique.name}",
                "-data-dir=/local",
                "-advertise=${attr.unique.network.ip-address}",
                "-bind=0.0.0.0",
                "-client=0.0.0.0",
                "-bootstrap-expect=3",
                "-datacenter=${meta.region}",
#                "-dns-port=53",
                "-recursor=169.254.169.254",
                "-retry-join=nomad-${meta.region}-1",
                "-retry-join=nomad-${meta.region}-2",
                "-retry-join=nomad-${meta.region}-3",
                "-retry-interval=5s",
                "-retry-join-wan=nomad-${meta.region}-1",
                "-retry-join-wan=nomad-${meta.region}-2",
                "-retry-join-wan=nomad-${meta.region}-3",
                "-retry-interval-wan=5s",
                "-ui"]
      }

      resources {
        cpu = 500
        memory = 128
        network {
          mbits = 1

          port "server" {
            static = 8300
          }
          port "serf_lan" {
            static = 8301
          }
          port "serf_wan" {
            static = 8302
          }
          port "rpc" {
            static = 8400
          }
          port "http" {
            static = 8500
          }
          port "dns" {
            static = 8600
          }
        }
      }
    }
  }

  group "consul-client" {
    constraint {
      attribute = "${node.class}"
      value = "farm"
    }

    task "consul-agent" {
      driver = "docker"
      config {
        image = "consul:0.7.0"
        network_mode="host"
        command = "agent"
        args = ["-node=${node.unique.name}",
                "-advertise=${attr.unique.network.ip-address}",
                "-bind=0.0.0.0",
                "-client=0.0.0.0",
                "-datacenter=${meta.region}",
                "-retry-join=nomad-${meta.region}-1",
                "-retry-join=nomad-${meta.region}-2",
                "-retry-join=nomad-${meta.region}-3",
                "-retry-interval=5s"]
      }

      resources {
        cpu = 500
        memory = 128
        network {
          mbits = 1

          port "server" {
            static = 8300
          }
          port "serf_lan" {
            static = 8301
          }
          port "serf_wan" {
            static = 8302
          }
          port "rpc" {
            static = 8400
          }
          port "http" {
            static = 8500
          }
          port "dns" {
            static = 8600
          }
        }
      }
    }
  }
}
