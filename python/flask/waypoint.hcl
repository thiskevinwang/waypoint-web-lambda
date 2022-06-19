project = "python"

config {
  runner {
    // All config in here is exposed only on runners.
    env = {
    }
  }

  // App config is here...
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/thiskevinwang/waypoint-web-lambda.git"
    path = "python/flask"
  }
}

app "flask" {
  build {
    use "docker" {
      buildkit   = true
      platform   = "arm64"
      dockerfile = "${path.app}/Dockerfile"
      // disable_entrypoint = true
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
        "PORT"                 = "8080"
        "READINESS_CHECK_PORT" = "8080"
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
  default     = "python-flask"
  type        = string
  description = "AWS ECR Repository Name"
}
variable "tag" {
  default     = "latest"
  type        = string
  description = "A tag"
}
