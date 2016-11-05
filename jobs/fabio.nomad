job "fabio" {
  region = "eu"
  datacenters = ["europe-west1-b","europe-west1-c","europe-west1-d"]
#  region = "us"
#  datacenters = ["us-central1-a","us-central1-b","us-central1-c","us-central1-f"]
#  region = "as"
#  datacenters = ["asia-east1-a","asia-east1-b","asia-east1-c"]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {
    task "fabio" {
      driver = "exec"
      config {
        command = "fabio-1.3.3-go1.7.1-linux_amd64"
        args = [
          "-registry.consul.addr", "127.0.0.1:8500",
          "-registry.consul.register.tags", "urlprefix-fabio.gce.nauts.io/"
        ]
      }

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-eu/fabio/fabio-1.3.3-go1.7.1-linux_amd64"
        options {
          checksum = "sha256:b4039172e7eff89b7a77ba0721cf0543473cf4bfaf502d72e6407f9aa619a3f6"
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
