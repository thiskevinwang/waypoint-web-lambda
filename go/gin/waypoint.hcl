project = "go"

// config {
//   env = {
//     "FOOBAR" = dynamic("terraform-cloud", {
//       organization = "waypoint"
//       workspace    = "go-gin"
//       output       = "foobar"
//     })
//   }
// }

// how to raise the 1Gi ephemeral storage limit for a container
task {
  use "kubernetes" {
    cpu    = "1000m"
    memory = "4Gi"
  }
}

variable "FOOBAR" {
  type = string
  default = dynamic("terraform-cloud", {
    organization = "waypoint"
    workspace    = "go-gin"
    output       = "foobar"
  })
}

app "gin" {
  build {
    use "docker" {
      buildkit = true
      // platform   = "amd64"
      platform           = "arm64"
      dockerfile         = "${path.app}/Dockerfile"
      disable_entrypoint = true
    }

    registry {
      use "aws-ecr" {
        region     = var.region
        repository = var.repository
        tag        = var.tag
      }
    }
  }

  deploy {
    use "aws-lambda" {
      region = var.region
      memory = 512
      static_environment = {
        FOOBAR = var.FOOBAR
        // "POSTGRES_HOST"     = var.DB_HOST
        // "POSTGRES_USER"     = var.DB_USER
        // "POSTGRES_PASSWORD" = var.DB_PASSWORD
        // "POSTGRES_PORT"     = var.DB_PORT
        // "POSTGRES_DB"       = "postgres"

        // "AUTH_TOKEN" = var.AUTH_TOKEN
        "GIN_MODE" = "release"
      }
    }
  }

  release {
    use "lambda-function-url" {

    }
  }
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS Region"
}
variable "repository" {
  default     = "go-gin"
  type        = string
  description = "AWS ECR Repository Name"
}
variable "tag" {
  default     = "latest"
  type        = string
  description = "A tag"
}

// variable "DB_HOST" {
//   type = string
// }

// variable "DB_USER" {
//   type = string
// }

// variable "DB_PASSWORD" {
//   type = string
// }
// variable "DB_PORT" {
//   type = string
// }

// variable "AUTH_TOKEN" {
//   type = string
//   // default = "FIXME"
// }