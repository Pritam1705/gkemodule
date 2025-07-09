variable "project_id" {}
variable "region" {}
variable "network" {}
variable "subnetwork" {}

variable "use_existing_sa" {
  type    = bool
  default = false
}

variable "service_account_email" {
  type    = string
  default = ""
}

variable "service_account_id" {
  type    = string
  default = "gke-sa"
}

variable "service_account_roles" {
  type    = list(string)
  default = [
    "roles/container.nodeServiceAccount",
    "roles/compute.networkViewer"
  ]
}

variable "cluster" {
  type = object({
    name                  = string
    location              = string
    enable_private_nodes  = optional(bool)
    master_ipv4_cidr_block = optional(string)
    default_node_config = object({
      machine_type = string
      disk_size_gb = number
      disk_type    = string
    })
  })
}

variable "node_pools" {
  type = map(object({
    initial_node_count = optional(number)
    min_node_count     = optional(number)
    max_node_count     = optional(number)
    node_config = object({
      machine_type        = string
      disk_size_gb        = number
      disk_type           = string
      spot                = optional(bool)
      labels              = optional(map(string))
      taints              = optional(list(object({
        key    = string
        value  = string
        effect = string
      })))
      guest_accelerators  = optional(list(object({
        type  = string
        count = number
      })))
    })
  }))
}
