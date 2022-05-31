project = "deno"

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
    path = "deno/http"
  }
}

app "deno-http" {
  build {
    // use "docker" {
    //   buildkit   = true
    //   // todo: must use amd64: the official deno image only supports amd64
    //   platform = "amd64"
    //   dockerfile = "${path.app}/Dockerfile"
    //   disable_entrypoint = true
    // }


    // registry {
    //   use "aws-ecr" {
    //     region     = var.region
    //     repository = "deno-http"
    //     tag        = var.tag
    //   }
    // }

    use "aws-ecr-pull" {
      region     = var.region
      repository = "deno-http"
      tag        = var.tag
    }
  }

  deploy {
    use "aws-lambda" {
      region = var.region
      memory = 256
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