output "foobar" {
  description = "Foobar"
  value       = resource.random_id.server.keepers.ami_id
}
