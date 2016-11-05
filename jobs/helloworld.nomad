job "helloworld" {
  region = "eu"
  datacenters = ["europe-west1-b","europe-west1-c","europe-west1-d"]
#  region = "us"
#  datacenters = ["us-central1-a","us-central1-b","us-central1-c","us-central1-f"]
#  region = "as"
#  datacenters = ["asia-east1-a","asia-east1-b","asia-east1-c"]
#  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "helloworld" {
    count = 3

    constraint {
      attribute = "${node.class}"
      value = "farm"
    }

    task "helloworld" {
      driver = "exec"
      config {
        command = "helloworld"
        args = ["from ${node.unique.name} in ${meta.zone}"]
      }

      // template {
      //   data = <<EOH
      //   {{range $dc := datacenters -}}
      //   {{$dc}}
      //       {{- $atdc := print "@" $dc -}}
      //       {{range services $atdc}}
      //       {{if ne .Name "helloworld" -}}{{.Name}} ({{.Tags}})
      //           {{$service := print .Name "@" $dc -}}
      //           {{- range service $service -}}
      //           {{.Address}}:{{.Port}}
      //           {{end}}{{end}}
      //       {{- end}}
      //   {{- end}}
      //   EOH
      //   destination = "foo.txt"
      //   change_mode = "noop"
      // }

      env {
        NOMAD_CUSTOM_VAR = "some custom value"
      }

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-eu/helloworld/helloworld"
        options {
          checksum = "sha256:c606532682729171325a15f8fa637edea517ed8b3181dea3451ca979f50f09a6"
        }
      }

      resources {
        cpu = 100
        memory = 64
        network {
          mbits = 1
          port "http" {}
        }
      }

      service {
        name = "helloworld"
        tags = ["urlprefix-helloworld.gce.nauts.io/"]
        port = "http"
        check {
          type = "http"
          name = "health"
          interval = "15s"
          timeout = "5s"
          path = "/health"
        }
      }
    }
  }
}
