# gcp-network — module design workshop

This folder is a **module exercise**, not a finished deployable module. Implement it after the corresponding cloud console lab and the Terraform language/modules lessons.

## Contract

- Inputs: region (via provider in root), names/tags, network CIDR or resource IDs, security settings.
- Resources: only the resources owned by this module; avoid duplicating resources in callers.
- Outputs: stable identifiers and connection details, never private keys or secrets.
- Validation: typed variables, CIDR/port validation, `terraform fmt`, `terraform validate`, `terraform test`.
- Documentation: expected charges, least-privilege defaults, replacement impact and cleanup.

## Exercise

Write `variables.tf`, `main.tf`, `outputs.tf` and a small root-module consumer. Use `terraform plan` to verify the caller supplies all required inputs. Compare to the manually created AWS/GCP networking or compute resources. Do not apply until you understand the full plan.
