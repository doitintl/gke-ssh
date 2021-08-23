resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_name
  org_id          = var.org_id
  billing_account = var.billing_account_id
}

resource "google_project_service" "container" {
  depends_on = [
    google_project.project,
    google_project_service.container
  ]

  project = var.project_name
  service = "container.googleapis.com"
}

resource "google_project_service" "containerregistry" {
  depends_on = [google_project.project]

  project = var.project_name
  service = "containerregistry.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "servicenetworking" {
  depends_on = [google_project.project]

  project = var.project_name
  service = "servicenetworking.googleapis.com"
}