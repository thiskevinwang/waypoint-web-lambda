# The name of your project. A project typically maps 1:1 to a VCS repository.
# This name must be unique for your Waypoint server. If you're running in
# local mode, this must be unique to your machine.
project = "wp-eks-fargate-express"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

# An application to deploy.
app "wp-eks-fargate-express" {
    # Build specifies how an application should be deployed. In this case,
    # we'll build using a Dockerfile and keeping it in a local registry.
    build {
        use "docker" {}
        

    registry {
      use "aws-ecr" {
        region     = var.region
        repository = "wp-eks-fargate-express"
        tag        = var.tag
      }
    }
    }

    # Deploy to Docker
    deploy {
        use "docker" {}
    }
}

variable "version" {
  default     = "latest"
  type        = string
  description = "Version"
}

variable "tag" {
  // default     = gitrefpretty()
  default     = "latest"
  type        = string
  description = "A tag"
}