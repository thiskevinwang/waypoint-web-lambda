project = "go"

app "gin" {
  build {
    use "docker" {
      buildkit   = true
      // platform   = "amd64"
      platform = "arm64"
 			dockerfile = "${path.app}/Dockerfile"
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
