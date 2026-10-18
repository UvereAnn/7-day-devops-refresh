# Copy into terraform/01-fundamentals/ before running `terraform test` there.
run "message_is_expected" {
  command = plan
  assert {
    condition     = terraform_data.hello.input == "Hello from Day 5 Terraform"
    error_message = "Unexpected greeting input"
  }
}
