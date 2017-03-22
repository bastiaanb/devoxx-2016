job "fabio" {
  region = "eu"
  datacenters = [
    "europe-west1-b","europe-west1-c","europe-west1-d",
    "us-central1-a","us-central1-b","us-central1-c","us-central1-f",
    "asia-east1-a","asia-east1-b","asia-east1-c"
  ]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {
#    constraint {
#      attribute = "${node.class}"
#      value = "farm"
#    }

    task "fabio" {
      driver = "exec"
      config {
        command = "fabio-1.3.8-go1.8-linux_amd64"
        args = [
          "-registry.consul.addr", "127.0.0.1:8500",
          "-registry.consul.register.tags", "urlprefix-fabio.gce.nauts.io/"
        ]
      }

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-${meta.region}/fabio/fabio-1.3.8-go1.8-linux_amd64"
        options {
          checksum = "sha256:21d1bf939e3079efafdb228b855411204ed6f4312d0a85fb34992958f4b9d7d0"
        }
      }

      resources {
        cpu = 500
        memory = 64
        network {
          mbits = 1

          port "http" {
            static = 9999
          }
          port "admin" {
            static = 9998
          }
        }
      }
    }
  }
}
