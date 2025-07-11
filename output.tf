output "standard_cluster_names" {
  value = [for k, v in google_container_cluster.standard : v.name]
}

output "autopilot_cluster_names" {
  value = [for k, v in google_container_cluster.autopilot : v.name]
}

output "standard_node_pool_names" {
  value = [for k, v in google_container_node_pool.standard_nodepool : v.name]
}

output "service_account_email" {
  value = var.use_existing_sa ? var.service_account_email : (
    length(google_service_account.gke_sa) > 0 ? google_service_account.gke_sa[0].email : null
  )
}
