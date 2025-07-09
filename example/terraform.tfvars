project_id            = "orbital-expanse-461308-h6"
region                = "asia-south1"
network               = ""
subnetwork            = ""
use_existing_sa       = true
service_account_email = "956225989142-compute@developer.gserviceaccount.com"
service_account_id    = "956225989142-compute"
service_account_roles = [
  "roles/container.nodeServiceAccount",
  "roles/compute.instanceAdmin.v1",
  "roles/iam.serviceAccountUser"
]
cluster = {
  name                 = "apnamart-devuat-cluster"
  location             = "asia-south1-a"
  enable_private_nodes = true
  default_node_config = {
    machine_type = "e2-medium"
    disk_size_gb = 50
    disk_type    = "pd-standard"
  }
}

node_pools = {
  "apnamart-nodepool-1" = {
    initial_node_count = 1
    min_node_count     = 1
    max_node_count     = 5
    node_config = {
      machine_type = "e2-medium"
      disk_size_gb = 50
      disk_type    = "pd-standard"
      spot         = false
      labels = {
        env = "devuat"
      }
      taints             = []
      guest_accelerators = []
    }

  },
  "apnamart-nodepool-2" = {
    initial_node_count = 1
    min_node_count     = 1
    max_node_count     = 5
    node_config = {
      machine_type = "e2-medium"
      disk_size_gb = 50
      disk_type    = "pd-standard"
      spot         = false
      labels = {
        env = "devuat"
      }
      taints             = []
      guest_accelerators = []
    }
  }
}

