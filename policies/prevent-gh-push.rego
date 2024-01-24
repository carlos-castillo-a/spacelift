package spacelift

deny["Do not deploy from GitHub"] {
  input.spacelift.run.type == "TRACKED"
  startswith(input.spacelift.run.triggered_by, "github/")
}