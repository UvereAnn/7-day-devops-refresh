# Google Cloud Lab 24 — DevSecOps, policy and governance

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

Google Cloud uses **IAM** for permissions, **Organization Policy** for constraints, **Cloud Audit Logs** for activity, **Security Command Center** for security posture, and **Artifact Analysis** for supported container/package vulnerability metadata. IAM and organization policies have different roles: IAM answers *who may do something*; organization policy answers *what configurations are allowed* at a resource hierarchy level.

## Guided practical exercise

**Console route:** IAM & Admin → IAM / Organization Policies; Logging → Logs Explorer; Security Command Center (check tier and pricing).

```bash
gcloud config get-value project
gcloud projects get-iam-policy "$(gcloud config get-value project)" --format='table(bindings.role)'
gcloud logging read 'logName:"cloudaudit.googleapis.com"' --limit=5 --format='table(timestamp,protoPayload.methodName)'
```

**Practice:** Identify a service account with an overly broad role in a hypothetical example, then propose a narrower role. Inspect an audit entry's `methodName` and principal fields. Audit logs have different categories and retention behavior; absence of an entry does not automatically mean no activity occurred. Review Artifact Registry vulnerability scanning options without enabling paid features blindly.

## Troubleshooting and interview practice

- **Question:** How do IAM and organizational guardrails differ?
- **Question:** What can audit logs tell you?
- **Question:** How should you prioritize vulnerability findings?

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
