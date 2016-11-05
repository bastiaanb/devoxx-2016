job "consul" {
  region = "eu"
  datacenters = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
#  datacenters = ["dc1"]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "consul-server" {
    constraint {
      attribute = "${node.class}"
      value = "system"
    }

    task "consul-agent" {
      driver = "exec"
      config {
        command = "consul"
        args = ["agent",
                "-server",
                "-data-dir=/var/lib/consul",
                "-node=${node.unique.name}",
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

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-eu/hashicorp/consul/0.7.0/consul_0.7.0_linux_amd64.zip"
        options {
          checksum = "sha256:b350591af10d7d23514ebaa0565638539900cdb3aaa048f077217c4c46653dd8"
        }
      }

      resources {
        cpu = 500
        memory = 64
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
      driver = "exec"
      config {
        command = "consul"
        args = ["agent",
                "-data-dir=/var/lib/consul",
                "-node=${node.unique.name}",
                "-advertise=${attr.unique.network.ip-address}",
                "-bind=0.0.0.0",
                "-client=0.0.0.0",
                "-datacenter=${meta.region}",
                "-retry-join=nomad-${meta.region}-1",
                "-retry-join=nomad-${meta.region}-2",
                "-retry-join=nomad-${meta.region}-3",
                "-retry-interval=5s"]
      }

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-eu/hashicorp/consul/0.7.0/consul_0.7.0_linux_amd64.zip"
        options {
          checksum = "sha256:b350591af10d7d23514ebaa0565638539900cdb3aaa048f077217c4c46653dd8"
        }
      }

      resources {
        cpu = 500
        memory = 64
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
