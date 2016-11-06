job "helloworld" {
  region = "eu"
  datacenters = [
    "europe-west1-b","europe-west1-c","europe-west1-d",
    "us-central1-a","us-central1-b","us-central1-c","us-central1-f",
    "asia-east1-a","asia-east1-b","asia-east1-c"
  ]
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
        command = "helloworld-1.0"
        args = ["from ${node.unique.name} in ${meta.zone}"]
      }

      env {
        LISTEN_ADDRESS = "${NOMAD_ADDR_http}"
      }

      artifact {
        source = "https://storage.googleapis.com/global-datacenter-${meta.region}/helloworld/helloworld-1.0"
        options {
          checksum = "sha256:ac5d68980d936a2966cf98776421acaf5a186b5d771a72991706595836334e21"
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

      # render list of all local 'helloworld' instances
      // template {
      //   data = "{{range service \"helloworld\" }}{{.Address}}:{{.Port}}\n{{end}}"
      //   destination = "peers.txt"
      //   change_mode = "noop"
      // }

      # render all instances of all services in all datacenters
//       template {
//         data = <<EOH
// {{range $dc := datacenters -}}
// {{$dc}}
//     {{- $atdc := print "@" $dc -}}
//     {{range services $atdc}}
//     {{.Name}} ({{.Tags}})
//         {{$service := print .Name "@" $dc -}}
//         {{- range service $service -}}
//         {{.Address}}:{{.Port}}
//         {{- end}}
//     {{- end}}
// {{- end}}
// EOH
//         destination = "services.txt"
//         change_mode = "noop"
//       }

    }
  }
}
