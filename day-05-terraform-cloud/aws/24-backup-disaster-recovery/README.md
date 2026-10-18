# AWS Lab 24 — Backup and disaster recovery

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

A **backup** is a recoverable copy; **disaster recovery** is the plan for restoring a service after a major failure. **RPO** (recovery point objective) is the maximum acceptable data loss measured in time; **RTO** (recovery time objective) is the maximum acceptable recovery duration. AWS offers EBS snapshots, RDS backups, S3 versioning, and AWS Backup. Backups should be tested by restoring, not merely by observing a green backup status.

## Guided practical exercise

**Console route:** EC2 → Volumes → Snapshots; S3 → Bucket → Properties → Versioning; AWS Backup → Backup plans (review charges). A low-risk lab is S3 versioning with a small text file.

```bash
BUCKET=YOUR_PRIVATE_LAB_BUCKET
aws s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled
printf 'version one
' > recovery-demo.txt
aws s3 cp recovery-demo.txt "s3://${BUCKET}/recovery-demo.txt"
printf 'version two
' > recovery-demo.txt
aws s3 cp recovery-demo.txt "s3://${BUCKET}/recovery-demo.txt"
aws s3api list-object-versions --bucket "$BUCKET" --prefix recovery-demo.txt
```

Identify the older `VersionId`, then use `aws s3api get-object --bucket "$BUCKET" --key recovery-demo.txt --version-id VERSION_ID restored.txt`. Confirm restored content with `cat restored.txt`. **Cleanup:** versioned buckets retain old object versions; remove all versions and delete markers before deleting the bucket. This lab teaches point-in-time recovery but does not replace a complete offsite backup plan.

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
