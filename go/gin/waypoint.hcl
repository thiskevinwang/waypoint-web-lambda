project = "go"

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
variable "branch" {
  default     = "main"
  type        = string
  description = "A branch"
}

app "gin" {
  build {
    hook {
      when    = "before"
      command = ["sh", "./scripts/create-db.sh", var.branch]
    }
    # use "docker" {
    #   buildkit = true
    #   platform = "amd64"
    #   # platform           = "arm64"
    #   dockerfile         = "${path.app}/Dockerfile"
    #   disable_entrypoint = true
    # }

    # registry {
    #   use "aws-ecr" {
    #     region     = var.region
    #     repository = var.repository
    #     tag        = var.tag
    #   }
    # }
    use "aws-ecr-pull" {
      region     = var.region
      repository = var.repository
      tag        = var.tag
    }
  }

  deploy {
    use "aws-lambda" {
      region       = var.region
      memory       = 512
      architecture = "arm64"
      # architecture = "x86_64"
    }
  }

  release {
    use "lambda-function-url" {
    }
  }
}


