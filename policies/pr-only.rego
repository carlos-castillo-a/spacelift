package spacelift

track   { is_pr; input.push.branch == input.stack.branch }
propose { is_pr }
ignore  { not is_pr }
is_pr   { not is_null(input.pull_request) }