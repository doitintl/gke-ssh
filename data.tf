data "google_client_config" "default" {}

data "google_project" "project" {
  depends_on = [google_project.project]
}

data "google_compute_subnetwork" "subnetwork" {
  depends_on = [module.vpc]

  name    = var.cluster_name
  project = var.project_name
  region  = var.region
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}