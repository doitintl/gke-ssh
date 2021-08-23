module "gke" {
  depends_on = [
    google_project_iam_member.iam_serviceaccountuser_gserviceaccount, google_project_iam_member.compute_admin_gserviceaccount,
    google_project_service.containerregistry,
    google_project.project
  ]

  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "16.0.1"

  project_id                  = var.project_name
  name                        = var.cluster_name
  region                      = var.region
  zones                       = var.zones
  master_ipv4_cidr_block      = var.master_ipv4_cidr_block
  network                     = module.vpc.network_name
  subnetwork                  = module.vpc.subnets_names[0]
  ip_range_pods               = "${var.cluster_name}-pods"
  ip_range_services           = "${var.cluster_name}-services"
  enable_private_endpoint     = false
  enable_private_nodes        = true
  http_load_balancing         = true
  horizontal_pod_autoscaling  = true
  network_policy              = true
  enable_binary_authorization = true
  remove_default_node_pool    = true

  node_pools = [
    {
      name         = "default-node-pool"
      machine_type = var.machine_type

      // Deploy only in the first AZ
      node_locations         = var.zones[0]
      min_count              = 1
      max_count              = 3
      local_ssd_count        = 0
      disk_size_gb           = 50
      disk_type              = "pd-standard"
      image_type             = "COS"
      auto_repair            = true
      auto_upgrade           = true
      preemptible            = false
      initial_node_count     = 3
      service_account        = "${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
      create_service_account = false
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }

  master_authorized_networks = var.authorized_networks

}

resource "google_service_account" "service_account" {
  depends_on = [google_project.project]

  account_id   = "tf-${var.cluster_name}"
  display_name = "GKE ${var.cluster_name} Service Account"
}

resource "google_project_iam_member" "stackdriver_resourceMetadata_writer" {
  project = var.project_name
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = var.project_name
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "containerregistry_ServiceAgent" {
  project = var.project_name
  role    = "roles/containerregistry.ServiceAgent"
  member  = "serviceAccount:${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "monitoring_metricWriter" {
  project = var.project_name
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "logging_logWriter" {
  project = var.project_name
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "compute_admin" {
  project = var.project_name
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.service_account.account_id}@${var.project_name}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "compute_admin_gserviceaccount" {
  depends_on = [google_project_service.container]

  project = var.project_name
  role    = "roles/compute.admin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "iam_serviceaccountuser_gserviceaccount" {
  depends_on = [google_project_service.container]

  project = var.project_name
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}