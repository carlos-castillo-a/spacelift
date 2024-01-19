### Policies ###
resource "spacelift_policy" "github" {
  name = "github-comment-notification"
  body = file("${path.module}/policies/github-comment.rego")
  type = "NOTIFICATION"
}

resource "spacelift_policy" "pr-only" {
  name = "pr-only-push"
  body = file("${path.module}/policies/github-comment.rego")
  type = "GIT_PUSH"
}

### Attachments ###
# resource "spacelift_policy_attachment" "github" {
#   policy_id = spacelift_policy.github.id
#   stack_id  = spacelift_space.spacelift.id
# }

# resource "spacelift_policy_attachment" "pr-only" {
#   policy_id = spacelift_policy.github.id
#   stack_id  = spacelift_space.spacelift.id
# }