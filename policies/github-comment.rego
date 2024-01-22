package spacelift

import future.keywords.contains
import future.keywords.if
import future.keywords.in

plan_header := sprintf("# ⚪️ [Planned changes](https://%s.app.spacelift.io/stack/%s/run/%s)\n\n![add](https://img.shields.io/badge/add-%d-brightgreen) ![change](https://img.shields.io/badge/change-%d-yellow) ![destroy](https://img.shields.io/badge/destroy-%d-red)\n\n| Action | Resource |\n| --- | --- |", [input.account.name, input.run_updated.stack.id, input.run_updated.run.id, count(added), count(changed), count(deleted)])
apply_header := sprintf("# 🟢 [Applied changes](https://%s.app.spacelift.io/stack/%s/run/%s)\n\n![add](https://img.shields.io/badge/add-%d-brightgreen) ![change](https://img.shields.io/badge/change-%d-yellow) ![destroy](https://img.shields.io/badge/destroy-%d-red)\n\n| Action | Resource |\n| --- | --- |", [input.account.name, input.run_updated.stack.id, input.run_updated.run.id, count(added), count(changed), count(deleted)])
fail_header := sprintf("# 🔴 [Failed to apply changes](https://%s.app.spacelift.io/stack/%s/run/%s)\n\n![add](https://img.shields.io/badge/add-%d-brightgreen) ![change](https://img.shields.io/badge/change-%d-yellow) ![destroy](https://img.shields.io/badge/destroy-%d-red)\n\n| Action | Resource |\n| --- | --- |", [input.account.name, input.run_updated.stack.id, input.run_updated.run.id, count(added), count(changed), count(deleted)])

addedresources := concat("\n", added)
changedresources := concat("\n", changed)
deletedresources := concat("\n", deleted)

added contains row if {
  some x in input.run_updated.run.changes
  row := sprintf("| Added | `%s` |", [x.entity.address])
  x.action == "added"
  x.entity.entity_type == "resource"
}

changed contains row if {
  some x in input.run_updated.run.changes
  row := sprintf("| Changed | `%s` |", [x.entity.address])
  x.entity.entity_type == "resource"
  any([x.action == "changed", x.action == "destroy-Before-create-replaced", x.action == "create-Before-destroy-replaced"])
}

deleted contains row if {
  some x in input.run_updated.run.changes
  row := sprintf("| Deleted | `%s` |", [x.entity.address])
  x.entity.entity_type == "resource"
  x.action == "deleted"
}


# Plan comment
pull_request contains {"commit": input.run_updated.run.commit.hash, "body": final_body} if {
  stack := input.run_updated.stack
  run := input.run_updated.run
  run.state == "FINISHED"
  run.type == "PROPOSED"

  policy_a_body := replace(replace(concat("\n", [plan_header, addedresources, changedresources, deletedresources]), "\n\n\n", "\n"), "\n\n", "\n")
  policy_b_body := sprintf(`>_⚠️ Changes will be deployed after merging PR. New comment will show results after merge._

## Planning logs

%s
spacelift::logs::planning
%s
`, ["```", "```"])

  final_body := concat("\n", [policy_a_body, policy_b_body])
}

# Post Merge comment
pull_request contains {"commit": input.run_updated.run.commit.hash, "body": final_body} if {
  stack := input.run_updated.stack
  run := input.run_updated.run
  run.state == "QUEUED"
  run.type == "TRACKED"

  final_body := "# 🟡 Deploy queued..."
}

# Apply comment
pull_request contains {"commit": input.run_updated.run.commit.hash, "body": final_body} if {
  stack := input.run_updated.stack
  run := input.run_updated.run
  run.state == "FINISHED"
  run.type == "TRACKED"

  policy_a_body := replace(replace(concat("\n", [apply_header, addedresources, changedresources, deletedresources]), "\n\n\n", "\n"), "\n\n", "\n")
  policy_b_body := sprintf(`

## Apply logs

%s
spacelift::logs::applying
%s
`, ["```", "```"])

  final_body := concat("\n", [policy_a_body, policy_b_body])
}

# Failed comment
pull_request contains {"commit": input.run_updated.run.commit.hash, "body": final_body} if {
  stack := input.run_updated.stack
  run := input.run_updated.run
  run.state == "FAILED"
  run.type == "TRACKED"

  policy_a_body := replace(replace(concat("\n", [fail_header, addedresources, changedresources, deletedresources]), "\n\n\n", "\n"), "\n\n", "\n")
  policy_b_body := sprintf(`

## Fail logs

%s
spacelift::logs::applying
%s
`, ["```", "```"])

  final_body := concat("\n", [policy_a_body, policy_b_body])
}