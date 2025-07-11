output "standard_cluster_names" {
  description = "Names of the standard (non-autopilot) GKE clusters"
  value       = [for k, v in google_container_cluster.standard : v.name]
}

output "autopilot_cluster_names" {
  description = "Names of the autopilot GKE clusters"
  value       = [for k, v in google_container_cluster.autopilot : v.name]
}

output "standard_node_pool_names" {
  description = "Names of all standard node pools"
  value       = [for k, v in google_container_node_pool.standard_nodepool : v.name]
}
