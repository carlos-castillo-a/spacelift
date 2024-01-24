### Policies ###
resource "spacelift_policy" "github" {
  name     = "github-comment-notification"
  body     = file("${path.module}/policies/github-comment.rego")
  type     = "NOTIFICATION"
  labels   = ["autoattach:*"]
  space_id = "root"
}

resource "spacelift_policy" "pr-only" {
  name     = "pr-only-push"
  body     = file("${path.module}/policies/pr-only.rego")
  type     = "GIT_PUSH"
  labels   = ["autoattach:*"]
  space_id = "root"
}

resource "spacelift_policy" "no-github-plan" {
  name     = "no-github-plan"
  body     = file("${path.module}/policies/prevent-gh-push.rego")
  type     = "PLAN"
  labels   = ["autoattach:*"]
  space_id = "root"
}