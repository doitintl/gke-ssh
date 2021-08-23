provider "google" {
  project = var.project_name
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.77.0"
    }
    kubernetes = {
      version = "~> 2.4.1"
    }
    null = {
      version = "~> 3.1.0"
    }
    external = {
      version = "~> 2.1.0"
    }
    random = {
      version = "~> 3.1.0"
    }
    helm = {
      version = "~> 2.2.0"
    }
  }
}