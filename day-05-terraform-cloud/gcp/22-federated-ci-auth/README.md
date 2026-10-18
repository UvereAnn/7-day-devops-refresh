# Google Cloud Lab 22 — Short-lived CI/CD credentials

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**Workload Identity Federation** lets external workloads such as GitHub Actions impersonate a Google Cloud service account without storing a service-account key. Google verifies the external token against a workload identity pool/provider and evaluates attribute conditions. IAM bindings then authorize the external principal to use the service account; that account's roles determine its Google Cloud permissions.

## Guided practical exercise

**Console route:** IAM & Admin → Workload Identity Federation → Create pool and provider → choose OIDC → issuer `https://token.actions.githubusercontent.com`. Configure attribute mappings and an attribute condition that restricts your GitHub repository; grant the external principal `roles/iam.workloadIdentityUser` on a dedicated service account.

```yaml
# .github/workflows/gcp-identity-check.yml
name: GCP identity check
on: workflow_dispatch
permissions:
  id-token: write
  contents: read
jobs:
  identity:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL/providers/PROVIDER
          service_account: github-lab@PROJECT_ID.iam.gserviceaccount.com
      - uses: google-github-actions/setup-gcloud@v2
      - run: gcloud auth list
```

Use actual project number (not project ID) in the provider path. A successful workflow shows an authenticated identity; it does **not** prove permissions to create resources. If authentication fails, inspect the provider issuer, mapped attributes, attribute condition, IAM binding, and repository claim. Never download a service-account JSON key for this lab.

## Troubleshooting and interview practice

- **Question:** What does an OIDC trust policy restrict?
- **Question:** Why are short-lived credentials safer than static keys?
- **Question:** Why must the workload still have IAM permissions?

**Troubleshooting method:** Identify whether the failure is in identity, permission, region, service configuration, network access, or application behavior. Read the exact error and relevant logs before changing settings. Do not broaden IAM permissions merely to make an error disappear.

## How to study and verify this lab

1. Read the explanation and identify the service's responsibility; do not confuse source hosting, build, deployment, and runtime.
2. Check the active cloud identity, account/project, region, IAM permissions, and billing before running commands.
3. Follow the console path, then run the CLI commands **one at a time** and explain each result.
4. Record your actual output, error messages, and how you resolved them. Never publish tokens, keys, account IDs, private URLs, or secret values.
5. Delete temporary resources and verify cleanup. Cloud charges may continue until deletion; alerts are not hard spending limits.

### Lab journal

- Date and cloud region:
- Identity used (role type only, not identifiers):
- Commands and console steps completed:
- Expected versus actual result:
- Error and diagnosis:
- Resources removed / remaining:
