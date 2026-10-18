# Google Cloud Lab 19 — Native infrastructure as code

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

Google Cloud has several infrastructure automation options, but **Infrastructure Manager is Terraform-based**, so it is not a Terraform-free equivalent of CloudFormation. **Config Connector** is a Kubernetes operator that reconciles Google Cloud resources from Kubernetes custom resources (CRDs); it requires a correctly configured cluster, IAM permissions, and Config Connector installation. **gcloud scripting** is useful automation but is *imperative*, not a native declarative IaC engine. For this first exercise, use the CLI to create and inspect a storage bucket; later compare the script with Config Connector YAML.

## Guided practical exercise

**Console route:** Google Cloud Console → select project → Cloud Storage → Buckets. Open Cloud Shell or configure `gcloud` locally. Confirm your project and billing before creating resources.

```bash
gcloud auth list
gcloud config get-value project
gcloud services enable storage.googleapis.com
PROJECT_ID="$(gcloud config get-value project)"
BUCKET="${PROJECT_ID}-iac-learning-$(date +%s)"
gcloud storage buckets create "gs://${BUCKET}" --location=europe-west1 --uniform-bucket-level-access
gcloud storage buckets describe "gs://${BUCKET}"
gcloud storage buckets delete "gs://${BUCKET}"
```

**What happens?** `gcloud storage buckets create` sends an API request immediately; it does not store desired state or detect drift like a declarative engine. Bucket names must be globally unique. Delete only the bucket you created.

**Config Connector example (study first; do not apply without installing the operator):**

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: example-config-connector-bucket
  annotations:
    cnrm.cloud.google.com/project-id: YOUR_PROJECT_ID
spec:
  location: EU
  uniformBucketLevelAccess: true
```

The operator watches this custom resource and reconciles the cloud bucket. Kubernetes YAML by itself does nothing without the Config Connector CRDs and controller. Use a globally unique bucket name, proper identity configuration, and review costs before attempting this advanced lab.

## Troubleshooting and interview practice

- **Question:** How does declarative IaC differ from a shell script?
- **Question:** What is the relationship between CDK and CloudFormation?
- **Question:** Why does Config Connector require a controller?

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
