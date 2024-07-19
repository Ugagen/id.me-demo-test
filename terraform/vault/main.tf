# Network and Firewall
resource "google_compute_network" "vault_network" {
  name                    = "vault-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vault_subnetwork" {
  name          = "vault-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vault_network.id
}

resource "google_compute_firewall" "vault_firewall" {
  name    = "vault-firewall"
  network = google_compute_network.vault_network.id

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  source_ranges = [var.allowed_ip]
}

# Vault Instance
resource "google_compute_instance" "vault_vm" {
  name         = "vault-vm"
  machine_type = var.machine_type
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vault_subnetwork.id
    access_config {
      # If you want to access Vault directly over the internet.
      # Note that this is for demonstration, consider load balancers in prod
    }
  }

  # Install Vault (adjust if you use a package manager or custom installation)
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y curl unzip
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install vault
    
    # Basic Vault config 
    sudo mkdir -p /etc/vault.d
    sudo mkdir -p /vault/data
    sudo chown -R vault:vault /vault
    sudo cat <<EOF > /etc/vault.d/vault.hcl
    storage "file" {
      path = "/vault/data"
    }
    listener "tcp" {
      address = "0.0.0.0:8200"
      tls_disable = 1  # Only for DEMO
    }
    ui = true # Enable Vault UI
    EOF
    sudo systemctl enable vault
    sudo systemctl start vault
  EOT
}

output "vault_public_ip" {
  value = google_compute_instance.vault_vm.network_interface.0.access_config.0.nat_ip
}
