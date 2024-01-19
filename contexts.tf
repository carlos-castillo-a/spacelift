# Spaclift Context
resource "spacelift_context" "spacelift" {
  description = "Configuration details for spaclift context."
  name        = "spacelift-context"

  labels   = ["autoattach:spacelift"]
  space_id = spacelift_space.spacelift.id # Attached to spacelift space
}

# Spacelift Variables
resource "spacelift_environment_variable" "prod-role-name" {
  context_id = spacelift_context.spacelift.id
  name       = "TF_VAR_prod_role_name"
  value      = "spacelift-prod-integration"
  write_only = true
}

resource "spacelift_environment_variable" "prod-account" {
  context_id = spacelift_context.spacelift.id
  name       = "TF_VAR_prod_account"
  value      = "231172330323"
  write_only = true
}

resource "spacelift_environment_variable" "prod-account-name" {
  context_id = spacelift_context.spacelift.id
  name       = "TF_VAR_prod_account_name"
  value      = "prod-castillo-a"
  write_only = true
}

# Production Context
resource "spacelift_context" "prod" {
  description = "Configuration details for prod context."
  name        = "prod-context"

  # Custom Hooks 
  after_init = ["terraform fmt -recursive -check"]

  labels   = ["autoattach:prod"]
  space_id = spacelift_space.prod.id # Attached to Prod space
}

# Prod Variables
resource "spacelift_environment_variable" "environment" {
  context_id = spacelift_context.prod.id
  name       = "TF_VAR_environment"
  value      = "prod"
  write_only = false
}

