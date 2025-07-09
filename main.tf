# main.tf

resource "google_container_cluster" "primary" {
  name     = var.cluster.name
  location = var.cluster.location
  project  = var.project_id
  network  = var.network
  subnetwork = var.subnetwork

  initial_node_count       = 1
  remove_default_node_pool = true
  deletion_protection      = false

  dynamic "private_cluster_config" {
    for_each = lookup(var.cluster, "enable_private_nodes", false) ? [1] : []

    content {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = var.cluster.master_ipv4_cidr_block
    }
  }

  node_config {
    machine_type    = var.cluster.default_node_config.machine_type
    disk_size_gb    = var.cluster.default_node_config.disk_size_gb
    disk_type       = var.cluster.default_node_config.disk_type
    service_account = var.use_existing_sa ? var.service_account_email : google_service_account.gke_sa[0].email

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_container_node_pool" "nodepools" {
  for_each = var.node_pools

  name     = each.key
  location = var.cluster.location
  cluster  = google_container_cluster.primary.name
  project  = var.project_id

  node_count = lookup(each.value, "initial_node_count", 1)

  autoscaling {
    min_node_count = lookup(each.value, "min_node_count", 1)
    max_node_count = lookup(each.value, "max_node_count", 3)
  }

  node_config {
    machine_type    = each.value.node_config.machine_type
    disk_size_gb    = each.value.node_config.disk_size_gb
    disk_type       = each.value.node_config.disk_type
    service_account = var.use_existing_sa ? var.service_account_email : google_service_account.gke_sa[0].email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    preemptible = lookup(each.value.node_config, "spot", false)
    labels      = lookup(each.value.node_config, "labels", {})

    dynamic "taint" {
      for_each = lookup(each.value.node_config, "taints", [])
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    dynamic "shielded_instance_config" {
      for_each = [1]
      content {
        enable_secure_boot          = true
        enable_integrity_monitoring = true
      }
    }

    dynamic "guest_accelerator" {
      for_each = lookup(each.value.node_config, "guest_accelerators", [])
      content {
        type  = guest_accelerator.value.type
        count = guest_accelerator.value.count
      }
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}

resource "google_service_account" "gke_sa" {
  count        = var.use_existing_sa ? 0 : 1
  account_id   = var.service_account_id
  display_name = "GKE Service Account"
}

resource "google_project_iam_member" "gke_sa_roles" {
  count   = var.use_existing_sa ? 0 : length(var.service_account_roles)
  project = var.project_id
  role    = var.service_account_roles[count.index]
  member  = "serviceAccount:${google_service_account.gke_sa[0].email}"
}

data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account_iam_member" "allow_gke_control_plane" {
  count              = var.use_existing_sa ? 0 : 1
  service_account_id = google_service_account.gke_sa[0].name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_project.current.number}@cloudservices.gserviceaccount.com"
}
