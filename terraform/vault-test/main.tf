terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_id" "random_pet" {
  byte_length = 4
}

output "random_pet" {
  value = random_id.random_pet.hex
}

output "secret_value" {
  value     = var.test
#   sensitive = true
}
