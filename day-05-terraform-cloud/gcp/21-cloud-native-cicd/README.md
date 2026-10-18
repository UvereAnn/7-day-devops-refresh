# Google Cloud Lab 21 — Cloud-native CI/CD

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**Cloud Build** runs build steps in managed environments; **Cloud Deploy** promotes releases across targets such as Cloud Run and GKE. Artifact Registry stores images, and Cloud Run runs them. These services form a pipeline but are not interchangeable.

**Console route:** Cloud Build → History/Triggers; Artifact Registry → Repositories; Cloud Deploy → Delivery pipelines. Start by validating the application with Cloud Build, not by deploying automatically.

## Guided practical exercise

In the root of a Node.js repository, create `cloudbuild.yaml`:

```yaml
steps:
  - name: 'node:22'
    entrypoint: 'bash'
    args:
      - '-c'
      - 'npm ci && npm test --if-present'
options:
  logging: CLOUD_LOGGING_ONLY
```

```bash
gcloud auth list
gcloud config get-value project
gcloud services enable cloudbuild.googleapis.com
gcloud builds submit --config cloudbuild.yaml .
gcloud builds list --limit=5
```

Commit a `package-lock.json` first; `npm ci` requires it. The build service account must have appropriate permissions to write logs. Open Cloud Build History and inspect each step's status and output. Later, build a container and push it to Artifact Registry; Cloud Deploy can then manage Cloud Run promotion with approvals. Builds and storage may incur charges, so check pricing and remove temporary resources.

## Troubleshooting and interview practice

- **Question:** What does a build stage verify?
- **Question:** What does an artifact registry store?
- **Question:** What is the difference between delivery and deployment?

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
