# Example Nomad jobspec for nomad-ui

job "nomad-ui" {
  region = "eu"
  datacenters = [
    "europe-west1-b","europe-west1-c","europe-west1-d",
    "us-central1-a","us-central1-b","us-central1-c","us-central1-f",
    "asia-east1-a","asia-east1-b","asia-east1-c"
  ]

  # run this job on the nomad servers
  type = "system"

  # Rolling updates should be sequential
  update {
    stagger      = "30s"
    max_parallel = 1
  }

  constraint {
    attribute = "${node.class}"
    value = "system"
  }

  group "servers" {
    # create a web front end using a docker image
    task "hashi-ui" {
      constraint {
        attribute = "${attr.kernel.name}"
        value     = "linux"
      }

      driver = "exec"

      config {
        command = "hashi-ui-linux-amd64"
      }

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-${meta.region}/hashi-ui/v0.13.4/hashi-ui-linux-amd64"
        options {
          checksum = "sha256:32a286c03fcd8b392bfce1f486f9b2a8d607c82393175e2b855388c7849a50c0"
        }
      }

      env {
        NOMAD_ENABLE = "1"
#        CONSUL_ENABLE = "1"
      }

      resources {
        cpu    = 500
        memory = 512

        network {
          mbits = 10

          # request for a static port
          port "http" {
            static = 3000
          }

          # use a dynamic port
          # port "http" {}
        }
      }

      service {
        name = "nomad-ui"
        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
