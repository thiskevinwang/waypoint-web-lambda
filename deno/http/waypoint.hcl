project = "deno"

app "deno-http" {
  build {
    use "docker" {
      buildkit   = true
      // todo: must use amd64: the official deno image only supports amd64
      platform = "amd64"
      dockerfile = "${path.app}/Dockerfile"
    }


    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "deno-http"
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