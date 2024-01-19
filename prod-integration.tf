# Locals
locals {
  role_name = var.prod_role_name
  role_arn  = "arn:aws:iam::${var.prod_account}:role/${local.role_name}"
}

# For role assumption
resource "spacelift_aws_integration" "this" {
  name = local.role_name

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.role_arn
  generate_credentials_in_worker = false
  duration_seconds               = 3600
  space_id                       = spacelift_space.spacelift.id
}

# Attach the integration to any stacks or modules that need to use it
resource "spacelift_aws_integration_attachment" "aws001-prod" {
  integration_id = spacelift_aws_integration.this.id
  stack_id       = spacelift_stack.aws001-prod.id
  read           = true
  write          = true
}
