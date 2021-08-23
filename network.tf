module "vpc" {
  depends_on = [
    google_project.project,
    google_project_service.servicenetworking
  ]

  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = var.project_name
  network_name = var.vpc_name

  subnets = [
    {
      subnet_name           = var.cluster_name
      subnet_ip             = var.subnet_ipv4_cidr_block
      subnet_region         = var.region
      subnet_private_access = true
      subnet_flow_logs      = true
    },
  ]

  secondary_ranges = {
    (var.cluster_name) = [
      {
        range_name    = "${var.cluster_name}-pods"
        ip_cidr_range = var.pods_ipv4_cidr_block
      },
      {
        range_name    = "${var.cluster_name}-services"
        ip_cidr_range = var.services_ipv4_cidr_block
      },
    ]
  }
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"

  project = var.project_name
  name    = var.router_name
  network = module.vpc.network_name
  region  = var.region

  nats = [{
    name = var.nat_name
  }]
}

resource "google_compute_firewall" "ssh_iap" {
  depends_on = [module.vpc]

  project       = var.project_name
  name          = "allow-ssh-from-iap"
  network       = var.vpc_name
  source_ranges = [var.iap_network]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}