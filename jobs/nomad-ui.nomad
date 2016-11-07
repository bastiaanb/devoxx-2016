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
    # we want one nomad-ui server
    count = 1

    # create a web front end using a docker image
    task "nomad-ui" {
      constraint {
        attribute = "${attr.kernel.name}"
        value     = "linux"
      }

      driver = "exec"

      config {
        command = "nomad-ui-linux-amd64"
      }

      artifact {
        source = "https://github.com/iverberk/nomad-ui/releases/download/v0.3.1/nomad-ui-linux-amd64"

        options {
          checksum = "sha256:cc4032e44f83b0a2dfcf4d05910b633a4eea2bea5d2d29d289d1c993c9fd748c"
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

      env {
#        NOMAD_ADDR = "http://nomad.service.consul:4646"
        NOMAD_ADDR = "http://127.0.0.1:4646"
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
    }
  }
}
