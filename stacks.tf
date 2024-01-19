# Stacks for AWS projects
resource "spacelift_stack" "aws001-prod" {
  name           = "terraform/aws001/prod"
  administrative = true
  autodeploy     = true
  space_id       = spacelift_space.prod.id

  # Source code
  repository   = "terraform"
  project_root = "AWS/aws001"
  branch       = "prod"
  description  = "Stack for project aws001 in prod environment"

  # Labels
  labels = ["prod", "aws"]
} 