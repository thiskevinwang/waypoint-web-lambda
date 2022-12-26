// https://www.waypointproject.io/docs/runner/profiles#adding-a-new-runner-profile

// ODR TASK Config

memory {
  request = "4Gi"
  limit   = "4Gi"
}

cpu {
  request = "900m" # K8s rounds this up to `1`
  limit   = "900m"
}

ephemeral_storage {
  request = "4Gi"
  limit   = "4Gi"
}

service_account = "waypoint-runner"