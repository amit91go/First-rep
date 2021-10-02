# This declares a job named "docs". There can be exactly one
# job declaration per job file.
job "assignment" {
  region = "global"
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    count = 1
    network {
      port "http" {}
    }
    task "frontend" {
      driver = "docker"
      config {
        image = "localhost:5000/webimage"
        ports = ["http"]
      }
      env {
	PORT = "${NOMAD_PORT_http}"
      }
      service {
        name = "frontend"
        port = "http"
        tags = [
          "frontend",
          "urlprefix-/",
        ]
        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
  group "search" {
    count = 1
    network {
      port "http" {
	static = 8081
      }
    }
    task "searchservice" {
      driver = "docker"
      config {
        image = "localhost:5000/searchimage"
        ports = ["http"]
      }
      env {
	PORT = "${NOMAD_PORT_http}"
      }
      service {
        name = "searchservice"
        port = "http"
        tags = [
          "searchservice",
          "urlprefix-/searchservice/ strip=/searchservice",
        ]
        check {
          type     = "http"
          path     = "/api/artists/search?artist=shakira"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
  group "cover" {
    count = 1
    network {
      port "http" {
	static = 8082
      }
    }
    task "coverservice" {
      driver = "docker"
      config {
        image = "localhost:5000/coverimage"
        ports = ["http"]
      }
      env {
	PORT = "${NOMAD_PORT_http}"
      }
      service {
        name = "coverservice"
        port = "http"
        tags = [
          "coverservice",
          "urlprefix-/coverservice/ strip=/coverservice",
        ]
        check {
          type     = "http"
          path     = "api/covers/2Cd9iWfcOpGDHLz6tVA3G4"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
  group "chart" {
    count = 1
    network {
      port "http" {
	static = 8083
      }
    }
    task "chartservice" {
      driver = "docker"
      config {
        image = "localhost:5000/chartimage"
        ports = ["http"]
      }
      env {
	PORT = "${NOMAD_PORT_http}"
      }
      service {
        name = "chartservice"
        port = "http"
        tags = [
          "chartservice",
          "urlprefix-/chartservice/ strip=/chartservice",
        ]
        check {
          type     = "http"
          path     = "api/charts/0EmeFodog0BfCgMzAIvKQp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
