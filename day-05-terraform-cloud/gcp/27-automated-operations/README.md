# Google Cloud Lab 27 — Event-driven operations and remediation

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

GCP **Eventarc** routes supported events to services such as Cloud Run, **Workflows** orchestrates API calls, and **Cloud Monitoring** generates alerts. Automation should be idempotent and include retries, dead-letter/error handling where appropriate, logging, and access controls. An event-triggered function that repeatedly changes a resource can accidentally cause loops.

## Guided practical exercise

**Console route:** Monitoring → Alerting; Eventarc → Triggers; Workflows → Workflows. Begin with a read-only investigation workflow rather than creating an automatic restart mechanism.

```bash
gcloud config get-value project
gcloud services list --enabled --filter='name:eventarc.googleapis.com OR name:workflows.googleapis.com'
gcloud workflows list --location=europe-west1
```

**Practice:** Sketch a flow: application error metric → alert → notification → human review → approved Workflow execution. Identify the service account permissions needed at each stage. To progress, build a Workflow that calls a read-only Google Cloud API with a dedicated service account. Check API enablement, region availability, and pricing before deploying.

## Troubleshooting and interview practice

- **Question:** What makes a remediation idempotent?
- **Question:** How can an event rule cause a loop?
- **Question:** What should be logged for an automated action?

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
