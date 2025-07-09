output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "node_pools" {
  value = [for np in google_container_node_pool.nodepools : np.name]
}
