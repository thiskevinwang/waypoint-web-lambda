project = "go"

app "gin" {
  build {
    use "docker" {
      buildkit   = true
      // platform   = "amd64"
      platform = "arm64"
      dockerfile = "${path.app}/Dockerfile"
    }

    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "go-gin"
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
    use "aws-lambda" {

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