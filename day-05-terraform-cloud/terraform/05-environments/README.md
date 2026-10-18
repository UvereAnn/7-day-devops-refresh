# Terraform Module 05 — Dev, test and production isolation

> **Status:** Full concept lesson with guided exercises. Commands are examples; no deployment is represented as completed.

## The concept, explained

Workspaces create separate state instances for the same configuration, but do not automatically create strong security boundaries. For meaningful dev/prod isolation, prefer separate accounts/projects and backend state paths, often with environment-specific root modules. Variables select sizing and tags, but should not hide unsafe production defaults.

### Why this matters in DevOps

A cloud engineer must know **what infrastructure should exist** and **how to prove it is correct**. Terraform adds repeatability, reviewable change plans and state tracking; it does not automatically make networking, IAM, application configuration or security correct. We will apply this module to our existing `devops-cicd-lab` app rather than inventing a new application.

## Read the configuration like an engineer

Terraform normally reads every `.tf` file in the current working directory as one root module. Filenames such as `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf` and `versions.tf` are conventions, not separate execution stages. A reference to another resource creates a dependency in the graph. Terraform compares configuration, state and remote APIs to decide changes.

### Core vocabulary

- **Provider:** Plugin that knows how to call a platform API.
- **Resource:** Managed object whose lifecycle Terraform tracks.
- **Data source:** Read-only lookup of an existing object.
- **Variable:** Input to a module, with optional type and validation.
- **Output:** Value exported by a module.
- **State:** Mapping between configuration addresses and managed real objects.
- **Plan:** Preview of changes, not a guarantee of future API success.

## Practical workshop

Try workspaces only with a local-file sandbox; notice that state and output can differ. Then sketch `environments/dev` and `environments/prod` with separate backends and credentials. Do not accidentally run `apply` against production.

### Commands to run or study

```bash
terraform workspace list
terraform workspace new dev
terraform workspace select dev
terraform workspace show
```

**Interpretation:** `init` prepares provider/backend dependencies; `fmt` formats HCL; `validate` checks configuration structure; `plan` proposes changes; `apply` changes infrastructure and may cost money; `destroy` removes managed resources and can delete data. Commands that depend on a configured cloud provider require a suitable identity and account/project. Run commands only inside the relevant example directory.

## Common mistakes and diagnosis

1. **Wrong working directory:** Terraform reads a different root module than expected. Confirm with `pwd` and `ls *.tf`.
2. **Missing provider or module:** Run `terraform init` and inspect version constraints.
3. **Authorization failure:** Verify the active AWS/GCP identity; do not solve by granting Administrator/Owner indiscriminately.
4. **Unexpected replacement:** Read the plan's `-/+` action and attributes forcing replacement before approving.
5. **State problems:** Stop concurrent applies, check lock owner, back up state, and use state commands only with a clear recovery plan.
6. **Cost surprises:** Review resource count, region, VM size, network egress and managed services before apply.

## Interview scenario

**Question:** Why are Terraform workspaces insufficient as a complete security isolation strategy?

**How to answer:** Define the concept, show a small HCL example or CLI command, explain a realistic failure, and state a safe operational practice. Tie the answer back to the AWS/GCP exercises and our Node.js application.

## Evidence checklist

- [ ] I can explain this topic without reading the README.
- [ ] I identified inputs, outputs and dependencies in the example.
- [ ] I ran the safe validation commands and understood the output.
- [ ] I reviewed a plan before any apply.
- [ ] I documented a failure mode and its diagnosis.
- [ ] I confirmed cleanup for any provisioned resources.

| Evidence | My observation |
|---|---|
| Directory and Terraform version | |
| Provider versions | |
| Plan summary | |
| Verified result | |
| Issue and fix | |
| Cleanup | |

**Reference:** [Terraform documentation](https://developer.hashicorp.com/terraform/docs). Return to the [masterclass index](../README.md).
