# Terraform Masterclass — AWS + GCP only

Terraform is learned here as a **language, workflow and engineering practice**. First work through the numbered modules; then complete the AWS and GCP application stacks. This is the same `devops-cicd-lab` Node.js project used in Days 2–4, now deployed through IaC. We do **not** cover Azure.

## Learning order

1. [Terraform workflow and mental model](01-fundamentals/README.md)
2. [HCL types, expressions and references](02-hcl-language/README.md)
3. [State, locking and remote backends](03-state-management/README.md)
4. [Root and child modules](04-modules/README.md)
5. [Dev, test and production isolation](05-environments/README.md)
6. [AWS infrastructure with Terraform](06-aws/README.md)
7. [GCP infrastructure with Terraform](07-gcp/README.md)
8. [Secrets, IAM, policy and state protection](09-secrets-security/README.md)
9. [Validation, linting and security tests](10-testing/README.md)
10. [Terraform GitHub Actions and approvals](11-cicd/README.md)
11. [Terraform with Kubernetes and Helm](12-kubernetes/README.md)
12. [Import, moved blocks, lifecycle and drift](13-advanced/README.md)
13. [Remote execution, governance and team workflows](14-enterprise/README.md)
14. [OpenTofu and compatibility](15-opentofu/README.md)

## Practical projects

- [AWS VPC + EC2 application](06-aws/vpc-ec2-app/README.md): networking, compute, image access, web health verification.
- [AWS three-tier design](06-aws/three-tier/README.md): ALB, Auto Scaling, private database and cost/security design.
- [GCP Cloud Run application](07-gcp/cloud-run-app/README.md): APIs, Artifact Registry, Cloud Run, IAM, port/health checks.
- [Reusable modules](modules/README.md): AWS network/compute and GCP network.
- [CI/CD validation](11-cicd/README.md): fmt, validate, security, plan and approvals.
- [Kubernetes provisioning](12-kubernetes/README.md): EKS/GKE concepts and provider bootstrapping.

## Safe working habits

1. Verify the current identity (`aws sts get-caller-identity` or `gcloud auth list`) and selected account/project.
2. `terraform init`, `terraform fmt`, `terraform validate`, then `terraform plan`.
3. Inspect every create/update/delete, resource count, public ingress, and expected charges.
4. Apply only when you have permission and a cleanup plan.
5. Confirm the app responds at `/` and `/health`; save redacted evidence.
6. Destroy disposable resources and verify cloud consoles/billing. State files, `.tfvars` with secrets, and cloud credentials must not be committed.

### Terraform's four critical files

```text
versions.tf    # required Terraform and provider versions
providers.tf   # provider configuration and aliases
variables.tf   # inputs and validation
main.tf        # resources, data sources and modules
outputs.tf     # selected results
```

Terraform loads them together, not in filename order. Use separate state for AWS and GCP roots. **A plan is not an apply, and an apply is not proof that the application is healthy.**
