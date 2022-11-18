variable "project_id" {
  description = "Project ID for the GKE cluster"
}

variable "cluster_name" {
  description = "Name of the GKE Cluster"
}

variable "region" {
  default = "us-central1"
}

variable "zones" {
  type = list(string)
  default = ["us-central1-a"]
}

variable "network" {
  description = "Network id for the cluster"
}

variable "subnetwork" {
  description = "Subnetwork id for the cluster"
}

variable "ip_range_pods" {
  description = "IP Range for the PODs"
}

variable "ip_range_services" {
  description = "IP Range for the Services"
}

