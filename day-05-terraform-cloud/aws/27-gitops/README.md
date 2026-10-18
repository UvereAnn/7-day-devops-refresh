# AWS Lab 27 — GitOps for Kubernetes

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**GitOps** treats a Git repository as the source of truth for Kubernetes desired state. A controller such as **Argo CD** or **Flux** compares Git manifests with the cluster and reconciles differences. GitOps is not simply `kubectl apply` inside a CI pipeline: reconciliation is ongoing, drift is detected, and the cluster pulls desired state. For AWS, EKS provides a managed Kubernetes control plane, while Argo CD/Flux run as controllers in the cluster. EKS can be expensive for a learning lab.

## Guided practical exercise

Use our existing Day 4 KIND cluster to understand GitOps before paying for EKS. **Prerequisites:** working `kubectl`, KIND cluster, and a repository containing reviewed Kubernetes manifests.

```bash
kubectl config current-context
kubectl get nodes
kubectl get namespaces
# Inspect a proposed app deployment manifest before syncing:
kubectl apply --dry-run=client -f kubernetes/base/
```

Install Argo CD or Flux only by following its current official instructions, then configure a read-only Git source and a limited namespace destination. Observe **Synced/OutOfSync** and **Healthy/Degraded** states. Change a replica count in Git, merge, and observe reconciliation; then manually change the cluster to demonstrate drift correction. Avoid exposing the Argo CD UI publicly. **AWS extension:** compare KIND with EKS authentication, IAM roles for service accounts/pod identity, node groups, load balancers, and cluster cost; do not create EKS solely for this introductory lab.

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
