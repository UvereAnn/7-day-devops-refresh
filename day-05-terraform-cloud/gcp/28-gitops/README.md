# Google Cloud Lab 28 — GitOps for Kubernetes

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

On GCP, GKE hosts Kubernetes workloads and GitOps controllers such as Argo CD or Flux can reconcile application manifests. GKE's cluster infrastructure is separate from the GitOps controller. Config Connector also uses reconciliation, but it manages Google Cloud resources through Kubernetes CRDs, whereas application GitOps commonly manages Kubernetes workloads.

## Guided practical exercise

Begin on the existing local KIND cluster, then compare with GKE. Confirm your kubeconfig context before any change:

```bash
kubectl config current-context
kubectl get nodes
kubectl get deployments -A
kubectl diff -f kubernetes/base/ || true
```

`kubectl diff` previews the difference between local manifests and live objects; GitOps controllers perform a related comparison against the Git source continuously. In a controlled lab, deploy Argo CD or Flux to KIND, register a read-only repo, and sync a single namespace. Observe a Git change triggering reconciliation. **GCP extension:** discuss GKE Workload Identity Federation for GKE, Artifact Registry image pulls, Cloud Logging, and regional costs before considering a managed cluster.

## Troubleshooting and interview practice

- **Question:** How does GitOps differ from CI running kubectl?
- **Question:** What is reconciliation/drift?
- **Question:** Why begin on KIND before EKS or GKE?

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
