variable "org_id" {
  type = string
}

variable "billing_account_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west4"
}

variable "zones" {
  type    = list(any)
  default = ["europe-west4-a", "europe-west4-b", "europe-west4-c"]
}

variable "cluster_name" {
  type    = string
  default = "gke-ssh"
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "vpc_name" {
  type    = string
  default = "gke-ssh"
}

variable "nat_name" {
  type    = string
  default = "gke-ssh"
}

variable "router_name" {
  type    = string
  default = "gke-ssh"
}

variable "ssh_user_name" {
  type = string
}

variable "ssh_user_key" {
  type = string
}

variable "iap_network" {
  type    = string
  default = "35.235.240.0/20"
}

variable "authorized_networks" {
  type = list(any)
  default = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  ]
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28"
}

variable "pods_ipv4_cidr_block" {
  type    = string
  default = "192.168.8.0/21"
}

variable "services_ipv4_cidr_block" {
  type    = string
  default = "192.168.16.0/21"
}

variable "subnet_ipv4_cidr_block" {
  type    = string
  default = "192.168.0.0/24"
}