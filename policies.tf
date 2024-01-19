### Policies ###
resource "spacelift_policy" "github" {
  name = "github-comment-notification"
  body = file("${path.module}/policies/github-comment.rego")
  type = "NOTIFICATION"

  space_id = spacelift_space.root.id
}

resource "spacelift_policy" "pr-only" {
  name = "pr-only-push"
  body = file("${path.module}/policies/github-comment.rego")
  type = "GIT_PUSH"

  space_id = spacelift_space.root.id
}
