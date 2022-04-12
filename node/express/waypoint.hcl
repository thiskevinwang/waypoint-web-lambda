project = "node"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

app "express" {
  build {
    use "docker" {}


    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "nodejs-express"
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