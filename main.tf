# Configure Terraform Cloud & Required Providers
terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

# Configure Spacelift Provided
provider "spacelift" {}