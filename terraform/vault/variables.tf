variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "allowed_ip" {
  type = string
}
