resource "kubernetes_namespace" "ssh-bastion" {
  metadata {
    name = "ssh-bastion"
  }
}

resource "helm_release" "ssh-bastion" {
  depends_on = [
    kubernetes_namespace.ssh-bastion,
  ]

  chart = "./helm/ssh-bastion"

  name      = "ssh-bastion"
  namespace = "ssh-bastion"
  values = [
    templatefile("${path.module}/helm/ssh-bastion/values.tmpl", {
      docker_image        = "gcr.io/${var.project_name}/ssh-bastion",
      docker_tag          = "latest"
      ssh_user_name       = var.ssh_user_name
      ssh_user_key        = var.ssh_user_key
      authorized_networks = var.authorized_networks[*].cidr_block
      }
    )
  ]
}

module "docker_build" {
  depends_on = [
    google_project.project,
    google_project_service.containerregistry
  ]

  source = "./modules/docker_build"

  gcp_project = var.project_name
  gcp_token   = data.google_client_config.default.access_token
  context     = "./helm/ssh-bastion/"
  name        = "ssh-bastion"
  tag         = "latest"
}