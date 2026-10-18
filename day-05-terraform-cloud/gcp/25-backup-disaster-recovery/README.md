# Google Cloud Lab 25 — Backup and disaster recovery

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

GCP offers Cloud Storage object versioning, Compute Engine disk snapshots, Cloud SQL backups, and Backup and DR services. A regional deployment and a backup solve different failure modes. Define RPO/RTO before choosing a backup interval or recovery architecture. For an introductory lab, use Cloud Storage object versioning and a small test file.

## Guided practical exercise

**Console route:** Cloud Storage → Buckets → select a test bucket → Protection → Object versioning. Then upload two versions of the same object and inspect version history.

```bash
BUCKET=YOUR_PRIVATE_LAB_BUCKET
gcloud storage buckets update "gs://${BUCKET}" --versioning
printf 'first version
' > recovery-demo.txt
gcloud storage cp recovery-demo.txt "gs://${BUCKET}/recovery-demo.txt"
printf 'second version
' > recovery-demo.txt
gcloud storage cp recovery-demo.txt "gs://${BUCKET}/recovery-demo.txt"
gcloud storage ls -a "gs://${BUCKET}/recovery-demo.txt"
```

The listed object generations identify historical versions. Use the console's version history to download an older generation and verify the content. **Cleanup:** disable versioning if no longer needed and delete all object generations before removing the bucket. Version retention increases storage costs.

## Troubleshooting and interview practice

- **Question:** Define RPO and RTO.
- **Question:** Why must backup restoration be tested?
- **Question:** What are the costs of object versioning?

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
