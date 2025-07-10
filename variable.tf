variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "network" {
  description = "VPC network name or self_link"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self_link"
  type        = string
}

variable "use_existing_sa" {
  description = "Set to true to use an existing service account"
  type        = bool
  default     = false
}

variable "service_account_email" {
  description = "Email of existing service account (used if use_existing_sa = true)"
  type        = string
  default     = ""
}

variable "service_account_id" {
  description = "ID for new service account (used if use_existing_sa = false)"
  type        = string
  default     = "gke-service-account"
}

variable "service_account_roles" {
  description = "IAM roles to attach to GKE service account"
  type        = list(string)
  default = [
    "roles/container.nodeServiceAccount",
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser"
  ]
}

variable "clusters" {
  description = "Map of GKE cluster configurations"
  type = map(object({
    name                   = string
    location               = string
    autopilot              = bool
    enable_private_nodes   = optional(bool, false)
    master_ipv4_cidr_block = optional(string)
    initial_node_count     = optional(number, 1)

    node_pools = optional(map(object({
      node_count     = optional(number, 1)
      min_node_count = optional(number, 1)
      max_node_count = optional(number, 3)
      machine_type   = string
      disk_size_gb   = number
      disk_type      = string
      spot           = optional(bool, false)
      labels         = optional(map(string), {})
      taints = optional(list(object({
        key    = string
        value  = string
        effect = string
      })), [])
    })), {})
  }))
}
