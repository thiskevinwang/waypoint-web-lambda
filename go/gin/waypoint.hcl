project = "wp-eks-go-gin"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

app "wp-eks-go-gin" {
  build {
    use "docker" {}


    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "wp-eks-go-gin"
        tag        = var.tag
      }
    }
  }

  # builtin/k8s/platform.go
  deploy {
    use "kubernetes" {
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 3000
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