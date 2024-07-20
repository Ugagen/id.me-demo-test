terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.50.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Random ID Generation for k8s
resource "random_id" "instance_name_suffix" {
  byte_length = 4
}

resource "google_compute_network" "my_vpc_network" {
  name                    = "k8s-network"
  auto_create_subnetworks = false 
}

resource "google_compute_subnetwork" "my_subnet" {
  name          = "k8s-subnet"
  region        = var.region
  network       = google_compute_network.my_vpc_network.name
  ip_cidr_range = "10.0.0.0/16" 

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
}

resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}-${random_id.instance_name_suffix.hex}"
  location           = var.region
  initial_node_count = 2

  networking_mode = "VPC_NATIVE"
  network    = google_compute_network.my_vpc_network.name
  subnetwork = google_compute_subnetwork.my_subnet.name
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  
  addons_config {
    http_load_balancing {
        disabled = false
    }
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 2
  
  node_config {
    machine_type = var.machine_type
    image_type   = "COS_CONTAINERD"
    disk_size_gb = 20
    disk_type    = "pd-ssd"
    tags         = ["env:production"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_locations = [ var.zone]

  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }
}