# Locals
locals {
  prod_role_arn  = "arn:aws:iam::${var.prod_account}:role/${var.prod_role_name}"
}

# For role assumption
resource "spacelift_aws_integration" "prod" {
  name = var.prod_account_name

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.prod_role_arn
  generate_credentials_in_worker = false
  duration_seconds               = 3600
  space_id                       = spacelift_space.spacelift.id

  # Auto attach
  labels = ["autoattach:prod"]
}

# Attach the integration to stacks
resource "spacelift_aws_integration_attachment" "aws001-prod" {
  integration_id = spacelift_aws_integration.prod.id
  stack_id       = spacelift_stack.aws001-prod.id
  read           = true
  write          = true
}