# GCP Terraform Project — Artifact Registry + Cloud Run + Existing App

## What this stack does

The included HCL enables Artifact Registry and Cloud Run APIs, creates an Artifact Registry Docker repository, and defines a Cloud Run v2 service pointing to an image in that repository. It does **not** build or publish the image, and it does **not** make the service publicly invokable. It is a starter that must be deployed in a careful sequence.

```text
Existing devops-cicd-lab source → Docker build → Artifact Registry
                                           ↓
Terraform Google provider → Cloud Run service → /health
```

## Critical app requirement

Cloud Run expects the app to listen on `0.0.0.0` at `process.env.PORT` (typically 8080). If the existing Node.js app is hardcoded to 3000, update its configuration and rebuild **before** deploying. The image `ghcr.io/uvereann/devops-cicd-lab:latest` is private; mirror/rebuild it into Artifact Registry using authorized access, not a public GHCR URL.

## Prerequisites

- Google Cloud project with billing and authorized IAM.
- gcloud installed; `gcloud auth list`, `gcloud config set project YOUR_PROJECT_ID`.
- Application Default Credentials or suitable workload identity for Terraform; avoid long-lived JSON keys.
- Docker, Terraform and an image that starts successfully with `PORT=8080`.

## Safe two-stage workflow

**Stage A — create repository and enable APIs.** The full configuration also includes Cloud Run, which references an image that does not yet exist. First provision just the prerequisite services/repository, then publish the image, then apply the full stack. Targeted apply is a bootstrap workaround, not a normal ongoing workflow; a dedicated bootstrap stack is cleaner for production.

```bash
cd day-05-terraform-cloud/terraform/07-gcp/cloud-run-app
gcloud auth list
terraform init
terraform fmt -check
terraform validate
terraform plan -var='project_id=YOUR_PROJECT_ID'
# For an initial bootstrap only, after plan review:
terraform apply -target=google_project_service.artifactregistry -target=google_artifact_registry_repository.app -var='project_id=YOUR_PROJECT_ID'
```

Next, configure Docker to authenticate to Artifact Registry, build an app image that honors `PORT`, tag it as `REGION-docker.pkg.dev/PROJECT/day5-app/devops-cicd-lab:v1`, and push it:

```bash
gcloud auth configure-docker europe-west1-docker.pkg.dev
# Run from the existing devops-cicd-lab source directory:
docker build -t europe-west1-docker.pkg.dev/YOUR_PROJECT_ID/day5-app/devops-cicd-lab:v1 .
docker push europe-west1-docker.pkg.dev/YOUR_PROJECT_ID/day5-app/devops-cicd-lab:v1
```

**Stage B — full apply:**

```bash
terraform plan -var='project_id=YOUR_PROJECT_ID'
terraform apply -var='project_id=YOUR_PROJECT_ID'
terraform output service_url
```

The service remains **private** by default unless appropriate invoker IAM is granted. Test with an authorized identity:

```bash
TOKEN="$(gcloud auth print-identity-token)"
curl -f -H "Authorization: Bearer ${TOKEN}" "YOUR_SERVICE_URL/health"
```

Your identity must have Cloud Run invoker permission. The container image also must be accessible to the Cloud Run service agent. If revision creation fails, inspect Cloud Run logs, image permissions and port binding.

## Cleanup

```bash
terraform destroy -var='project_id=YOUR_PROJECT_ID'
```

Confirm no images or other billable resources remain; API enablement is deliberately not disabled on destroy. Never delete a shared Artifact Registry repository or project accidentally.
