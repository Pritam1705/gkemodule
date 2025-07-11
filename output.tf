output "standard_cluster_names" {
  value = [for c in google_container_cluster.standard : c.name]
}

output "autopilot_cluster_names" {
  value = [for c in google_container_cluster.autopilot : c.name]
}

output "cluster_endpoints" {
  value = {
    for k, c in google_container_cluster.standard : k => c.endpoint
  }
}

output "autopilot_endpoints" {
  value = {
    for k, c in google_container_cluster.autopilot : k => c.endpoint
  }
}
