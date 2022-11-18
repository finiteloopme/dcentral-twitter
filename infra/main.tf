resource "google_project_service" "gkehub" {
  project = var.project_id
  service = "gkehub.googleapis.com"
  disable_dependent_services = false # this most likely will run in a multitenant demo env
  disable_on_destroy = false # this most likely will run in a multitenant demo env
}

resource "google_project_service" "gkeconnect" {
  project = var.project_id
  service = "gkeconnect.googleapis.com"
  disable_dependent_services = false # this most likely will run in a multitenant demo env
  disable_on_destroy = false # this most likely will run in a multitenant demo env
}

module "hub" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  project_id       = var.project_id
  cluster_name     = module.gke.name
  enable_fleet_registration = true
  location = module.gke.location

  depends_on = [
    google_project_service.gkehub,
    google_project_service.gkeconnect,
  ]
}

data "google_client_config" "default" {}

data "google_project" "project" {
  project_id = var.project_id
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  project_id              = var.project_id
  name                    = var.cluster_name
  regional                = false
  region                  = var.region
  zones                   = var.zones
  release_channel         = "REGULAR"
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  network_policy          = false
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
  identity_namespace      = "${var.project_id}.svc.id.goog"
  node_pools = [
    {
      name         = "asm-node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 3
      machine_type = "e2-standard-4"
    },
  ]
}

# resource "google_project_service" "mesh" {
#   project = var.project_id
#   service = "mesh.googleapis.com"
#   disable_dependent_services = false # this most likely will run in a multitenant demo env
#   disable_on_destroy = false # this most likely will run in a multitenant demo env
# }

# module "asm" {
#   source                    = "terraform-google-modules/kubernetes-engine/google//modules/asm"
#   project_id                = var.project_id
#   cluster_name              = module.gke.name
#   cluster_location          = module.gke.location
#   multicluster_mode         = "connected"
#   enable_cni                = true
#   enable_fleet_registration = true
#   enable_mesh_feature       = true
#   fleet_id = module.hub.cluster_membership_id
#   depends_on = [
#     google_project_service.mesh
#   ]
# }
