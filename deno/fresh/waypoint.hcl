project = "deno"

app "deno-fresh" {
  build {
    use "docker" {
      buildkit   = true
      platform   = "amd64"
 			dockerfile = "${path.app}/Dockerfile"
      disable_entrypoint = true
    }


    registry {
      use "docker" {
        image = "${var.registry_hostname}/${var.gcp_project}/${var.repository_name}/${var.image_name}"
        tag   = var.image_tag
      }
    }
  }

  deploy {
    use "google-cloud-run" {
      project  = var.gcp_project
      location = var.gcp_location

      port = 8000

      static_environment = {
        "NAME" : "World"
      }

      capacity {
        memory                     = 256
        cpu_count                  = 1
        max_requests_per_container = 10
        request_timeout            = 300
      }


      auto_scaling {
        max = 10
      }
    }
  }

  release {
    use "google-cloud-run" {}
  }
}

variable "gcp_location" {
  default     = "us-central1"
  type        = string
  description = "GCP Region"
}

variable "registry_hostname" {
  default     = "us-east1-docker.pkg.dev"
  type        = string
  description = "GCP Artifact Registry Hostname"
}
variable "repository_name" {
  default     = "deno-fresh"
  type        = string
  description = "GCP Repository Name"
}
variable "image_name" {
  default     = "deno-fresh"
  type        = string
  description = "Image name"
}
variable "image_tag" {
  default     = "latest"
  type        = string
  description = "A tag"
}
variable "gcp_project" {
  type        = string
  description = "GCP Project Name; Ex, foo-bar-112233"
}
