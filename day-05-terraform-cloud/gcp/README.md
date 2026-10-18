# GCP Cloud Engineering — Learn by Doing

This is a **teaching course**, not a checklist. Start with the concept explanation, follow the console walkthrough, run commands only in the specified environment, interpret their results, then troubleshoot and clean up. Every module is a guided lab; no cloud operation is claimed to have been performed on your behalf.

## Why this track matters

Cloud engineering involves **identity, networking, compute, storage, application delivery, observability and cost control**. We learn to operate these services manually before asking Terraform to automate them. We will use a disposable Nginx page first, then relate the lessons to our existing [`devops-cicd-lab`](https://github.com/UvereAnn/devops-cicd-lab) Node.js app.

## How to access resources

| Purpose | Google Cloud approach | What it actually connects to |
|---|---|---|
| Graphical administration | Google Cloud Console | Cloud service APIs |
| Browser terminal | Cloud Shell | Cloud service APIs via CLI |
| Ubuntu terminal | gcloud CLI / client libraries | Cloud service APIs |
| VM login | Browser SSH / gcloud compute ssh | Linux OS on a VM |
| Private VM administration | IAP TCP forwarding | Managed/private VM session when configured |
| Application access | Browser, `curl`, DNS, load balancer | Running HTTP service |

A login to a VM does **not** automatically authorize API calls; those require IAM and a workload identity/role.

## Guided learning modules

1. [GCP resource hierarchy, projects and access](01-gcp-fundamentals-access/README.md)
2. [GCP IAM and service accounts](02-iam-service-accounts/README.md)
3. [Global VPCs, regional subnets and firewall rules](03-vpc-networking/README.md)
4. [Compute Engine VM and SSH access](04-compute-engine-ssh/README.md)
5. [Host a web page on a GCP VM](05-vm-web-hosting/README.md)
6. [Cloud Storage buckets and objects](06-cloud-storage/README.md)
7. [Persistent Disk, Hyperdisk and Filestore](07-disks-filestore/README.md)
8. [Cloud SQL, Firestore and Spanner](08-databases/README.md)
9. [Load balancing and managed instance groups](09-load-balancing-autoscaling/README.md)
10. [Artifact Registry and GKE](10-artifact-registry-gke/README.md)
11. [Cloud Run serverless containers](11-cloud-run/README.md)
12. [Cloud Run functions and Eventarc](12-functions-eventarc/README.md)
13. [Cloud DNS, Cloud CDN and HTTPS](13-cloud-dns-cdn/README.md)
14. [Cloud Logging, Monitoring and Audit Logs](14-monitoring-logging/README.md)
15. [Pub/Sub messaging and BigQuery analytics](15-pubsub-bigquery/README.md)
16. [Secret Manager, Cloud KMS and secure workload identity](16-secrets-encryption/README.md)
17. [Structured GCP diagnostics](17-troubleshooting/README.md)
18. [GCP billing, budgets and cleanup](18-billing-cleanup/README.md)

## End-to-end progression

1. Inspect the account/project, active identity, region and billing.
2. Build a VPC/subnet, launch an Ubuntu VM, and connect from your **local Ubuntu terminal**.
3. Install Nginx, test `localhost`, then test the public IP and learn how firewall rules affect reachability.
4. Explore object storage, databases, containers, serverless, logging and monitoring with smaller disposable labs.
5. Document troubleshooting evidence and tear down resources.
6. Use Terraform to automate the same infrastructure in [`../terraform/README.md`](../terraform/README.md).

**Cost rule:** Check pricing before creating any resource; managed databases, Kubernetes clusters, load balancers, NAT, IPs and storage may cost money even when unused. Budget alerts are not hard spending limits.


## Additional cloud-native DevOps modules (10 concepts)

These are detailed lessons with provider-specific explanations, console paths, commands, troubleshooting, and interview practice. They are **not yet executed**.

1. [Native infrastructure as code](19-native-iac/README.md) — Lab 19
2. [Cloud source repositories](20-source-repositories/README.md) — Lab 20
3. [Cloud-native CI/CD](21-cloud-native-cicd/README.md) — Lab 21
4. [Short-lived CI/CD credentials](22-federated-ci-auth/README.md) — Lab 22
5. [Configuration and fleet management](23-configuration-management/README.md) — Lab 23
6. [DevSecOps, policy and governance](24-devsecops-governance/README.md) — Lab 24
7. [Backup and disaster recovery](25-backup-disaster-recovery/README.md) — Lab 25
8. [Rolling, blue-green and canary releases](26-deployment-strategies/README.md) — Lab 26
9. [Event-driven operations and remediation](27-automated-operations/README.md) — Lab 27
10. [GitOps for Kubernetes](28-gitops/README.md) — Lab 28
