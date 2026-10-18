# Google Cloud Lab 20 — Cloud source repositories

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**Google Cloud Secure Source Manager** provides managed private Git repositories with IAM-based access and pull-request workflows. It is distinct from Cloud Build (build execution) and Cloud Deploy (release orchestration). The older Cloud Source Repositories service is not available to new customers. Secure Source Manager may require an enabled API, appropriate IAM roles, supported region, and an instance before you can create repositories.

## Guided practical exercise

**Console route:** Secure Source Manager → create an instance (if required) → Repositories → Create. Review instance pricing before provisioning. Create a temporary repository named `devops-ssm-lab` and use the repository's displayed clone URL and authentication instructions rather than guessing the hostname.

```bash
gcloud auth list
gcloud config get-value project
gcloud services enable securesourcemanager.googleapis.com
# Discover supported CLI commands for your installed gcloud version:
gcloud source-manager --help
# Clone using the exact URL provided in the console:
git clone REPOSITORY_CLONE_URL
cd devops-ssm-lab
git remote -v
git status
```

Add a small README, commit, and push; then inspect the commit in the cloud console. **Why not hardcode a clone command?** Repository URLs and credential mechanisms depend on the configured instance and supported authentication mode. A 403 indicates permissions or identity issues; a 404 can indicate an incorrect instance/repository path. Remove the temporary repository and instance if no longer needed.

## Troubleshooting and interview practice

- **Question:** What is the difference between a Git host and a CI service?
- **Question:** What would cause a Git clone to return 403?
- **Question:** When might a cloud-hosted repository be useful?

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
