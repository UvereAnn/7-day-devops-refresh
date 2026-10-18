# Google Cloud Lab 26 — Rolling, blue-green and canary releases

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

Cloud Run revisions are immutable deployment snapshots, and a service can split traffic among revisions. This makes canary and rollback concepts concrete without managing virtual machines. Cloud Deploy can coordinate promotion across environments. A revision receiving 10% of traffic is a canary, not an automatic guarantee of safety; inspect error rates and latency before increasing traffic.

## Guided practical exercise

**Console route:** Cloud Run → Services → select your existing lab service → Revisions → Manage traffic. Deploy a second revision (e.g., change a safe environment variable or image tag), keep the previous revision, and assign a small percentage to the new one. Confirm both revisions are healthy before shifting more traffic.

```bash
gcloud run services list --region=europe-west1
gcloud run revisions list --service=YOUR_SERVICE --region=europe-west1
# Only after confirming actual revision names:
gcloud run services update-traffic YOUR_SERVICE   --region=europe-west1   --to-revisions=REVISION_NEW=10,REVISION_OLD=90
```

Check Cloud Run request/error metrics and application logs. Roll back by routing 100% to the old revision. Traffic-splitting tests require an existing service and may incur request or instance costs. Use revision names shown by the CLI; do not guess them.

## Troubleshooting and interview practice

- **Question:** Compare rolling, blue-green, and canary.
- **Question:** How does a health check influence rollback?
- **Question:** What is a Cloud Run revision?

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
