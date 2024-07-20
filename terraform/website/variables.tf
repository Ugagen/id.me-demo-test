variable "project_id" {
  type    = string
  default = "idme-demo-429818"
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "cluster_name" {
  type    = string
  default = "k8s-cluster"
}