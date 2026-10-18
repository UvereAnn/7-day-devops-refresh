# AWS Lab 21 — Short-lived CI/CD credentials

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

A CI runner must authenticate to cloud APIs, but putting permanent AWS access keys in GitHub secrets creates rotation and leakage risks. **OIDC federation** lets GitHub Actions obtain a signed identity token, which AWS STS exchanges for short-lived role credentials through `AssumeRoleWithWebIdentity`. The role's trust policy must restrict **audience** and **subject** to the intended repository and branch/environment. The IAM permissions policy then restricts *what* the workflow can do. Trust and permissions solve different problems.

## Guided practical exercise

**Console route:** IAM → Identity providers → Add provider (OpenID Connect) → GitHub's issuer `https://token.actions.githubusercontent.com`, audience `sts.amazonaws.com`. Then IAM → Roles → create a role with a narrowly scoped trust policy. Replace `ACCOUNT_ID`, `OWNER`, and `REPO` before use:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"},
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
        "token.actions.githubusercontent.com:sub": "repo:OWNER/REPO:ref:refs/heads/main"
      }
    }
  }]
}
```

```yaml
# .github/workflows/aws-identity-check.yml
name: AWS identity check
on: workflow_dispatch
permissions:
  id-token: write
  contents: read
jobs:
  identity:
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/GitHubLabRole
          aws-region: eu-west-1
      - run: aws sts get-caller-identity
```

The role can initially have no resource-management permissions; identity verification is enough for this exercise. Never print OIDC tokens. Restrict GitHub workflow permissions and protect the main branch. Delete the role and identity provider only if they are not shared with other workflows.

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
