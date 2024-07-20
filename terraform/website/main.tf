# Random ID Generation for k8s
resource "random_id" "instance_name_suffix" {
  byte_length = 4
}

resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}-${random_id.instance_name_suffix.hex}"
  location           = var.gcp_region
  initial_node_count = 2

  # ... (other cluster configurations)
}

resource "google_container_node_pool" "primary_pool" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  # ... (other node pool configurations)

  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }
}