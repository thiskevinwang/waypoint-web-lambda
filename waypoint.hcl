project = "wp-eks-express"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

app "wp-eks-express" {
  build {
    use "docker" {}


    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "wp-eks-express"
        tag        = var.tag
      }
    }
  }

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

variable "version" {
  default     = "latest"
  type        = string
  description = "Version"
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