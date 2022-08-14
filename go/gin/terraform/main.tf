# CLI driven workflow
terraform {
  cloud {
    organization = "waypoint"
    workspaces {
      name = "go-gin"
    }
  }
}


resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "test-value"
  }

  byte_length = 8
}
