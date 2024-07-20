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

resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}-${random_id.instance_name_suffix.hex}"
  location           = var.region
  initial_node_count = 2

  # ... (other cluster configurations)
}

resource "google_container_node_pool" "primary_pool" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"  
    services_secondary_range_name = "services"
  }
  master_authorized_networks_config {
  cidr_blocks {
    cidr_block   = "10.10.0.0/16" 
    display_name = "local-network"
    }
  }
  node_config {
  machine_type = var.machine_type
  image_type   = "COS"
  disk_size_gb = 20
  oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring"
    ]
    }
  addons_config {
    http_load_balancing {
        disabled = true
    }
  }
  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }
}