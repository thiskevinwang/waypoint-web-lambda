project = "node"

app "next" {
  build {
    use "docker" {
      buildkit   = true
      platform = "arm64"
      dockerfile = "${path.app}/Dockerfile"
      disable_entrypoint = true
    }

    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "node-next"
        tag        = var.tag
      }
    }
  }

  deploy {
    use "aws-lambda" {
      region = var.region
      memory = 512
      static_environment = {
        "PORT" = "8080"
        "READINESS_CHECK_PORT" = "8080"
      }
    }
  }

  release {
    use "lambda-function-url" {

    }
  }
}

variable "tag" {
  default     = "latest"
  type        = string
  description = "A tag"
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS Region"
}