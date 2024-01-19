# Stacks for AWS projects
resource "spacelift_stack" "aws001-prod" {
  # Github custom app
  github_enterprise {
    namespace = "carlos-castillo-a"
  }

  name           = "terraform/aws001/prod"
  administrative = false
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