# Spacelift Space (DO NOT DELETE)
resource "spacelift_space" "spacelift" {
  name            = "spacelift"
  parent_space_id = "root"
  description     = "This is a space dedicated to spacelift resources managed by this repo."

  labels           = ["spacelift"]
  inherit_entities = true
}

# Production Space
resource "spacelift_space" "prod" {
  name            = "prod"
  parent_space_id = spacelift_space.spacelift.id
  description     = "This is a space dedicated to production resources."

  labels           = ["prod"]
  inherit_entities = true
}