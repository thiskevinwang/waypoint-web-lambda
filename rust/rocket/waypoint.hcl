project = "rust"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

app "rocket" {
  build {
    use "docker" {
      buildkit   = true
      // platform   = "amd64"
      platform = "arm64"
      dockerfile = "${path.app}/Dockerfile"
    }

    # Use this for production deployment
    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "rust-rocket"
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