project = "node"

app "express" {
  build {
    use "docker" {
      buildkit           = true
      platform           = "amd64"
      dockerfile         = "${path.app}/Dockerfile"
      disable_entrypoint = false
    }

    hook {
      when       = "before"
      command    = ["sh", "./hooks/prebuild.sh", var.gitrefname]
      on_failure = "fail"
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
      static_environment = {
        "PORT"                 = "8080"
        "READINESS_CHECK_PORT" = "8080"
        "DB_HOST"              = var.DB_HOST
        "DB_USER"              = var.DB_USER
        "DB_PASSWORD"          = var.DB_PASSWORD
        "DB_PORT"              = var.DB_PORT

        # This needs to be dynamic
        "DB_DATABASE" = var.gitrefname
      }
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
  default     = "nodejs-express"
  type        = string
  description = "AWS ECR Repository Name"
}
variable "tag" {
  default     = "latest"
  type        = string
  description = "A tag"
}
########################
# INPUT
########################
variable "gitrefname" {
  default     = "main"
  type        = string
  description = "Git Ref Name"
}

// variable "tfc_organization" {
//   default = "waypoint"
//   type    = string
// }
// variable "tfc_workspace" {
//   default = "node-express"
//   type    = string
// }

variable "tfc_token" {
  type        = string
  description = "TFC Token"
}

########################################################
# Map terraform cloud outputs to waypoint variables
########################################################
variable "DB_HOST" {
  type = string
  default = dynamic("terraform-cloud", {
    organization = "waypoint"
    workspace    = "node-express"
    output       = "aurora_postgresql_serverlessv2_cluster_endpoint"
    token        = var.tfc_token
  })
}

variable "DB_USER" {
  type = string
  default = dynamic("terraform-cloud", {
    organization = "waypoint"
    workspace    = "node-express"
    output       = "aurora_postgresql_serverlessv2_cluster_master_username"
    token        = var.tfc_token
  })
}

variable "DB_PASSWORD" {
  type = string
  default = dynamic("terraform-cloud", {
    organization = "waypoint"
    workspace    = "node-express"
    output       = "aurora_postgresql_serverlessv2_cluster_master_password"
    token        = var.tfc_token
  })
}
variable "DB_PORT" {
  type = string
  default = dynamic("terraform-cloud", {
    organization = "waypoint"
    workspace    = "node-express"
    output       = "aurora_postgresql_serverlessv2_cluster_endpoint_port"
    token        = var.tfc_token
  })
}
      