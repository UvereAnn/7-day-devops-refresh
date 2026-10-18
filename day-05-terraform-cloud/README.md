# Day 5 — AWS, Google Cloud and Terraform Masterclass

Welcome to **Day 5 of the 7-Day DevOps Refresh**. This is a complete learning track organized into three connected courses, with detailed concept explanations, console walkthroughs, terminal exercises, troubleshooting, interview prompts and lab journals. **Azure is excluded.**

## What is the difference between the three tracks?

1. [AWS Cloud Engineering](aws/README.md) — learn how cloud infrastructure works by using the AWS Console, CloudShell, Ubuntu AWS CLI, EC2 SSH, Nginx, S3, IAM, networking and more. Start here.
2. [Google Cloud Engineering](gcp/README.md) — repeat comparable skills in Google Cloud Console, Cloud Shell, local gcloud, Compute Engine SSH, Nginx, Cloud Storage, Cloud Run and more.
3. [Terraform Masterclass](terraform/README.md) — describe and provision AWS/GCP infrastructure as code, manage state/modules, automate CI/CD, test and secure changes, and explore EKS/GKE and OpenTofu.

**Our application:** [`devops-cicd-lab`](https://github.com/UvereAnn/devops-cicd-lab), the existing Node.js/Express app with `/` and `/health` endpoints, Docker image and GitHub Actions. We do not duplicate the app; our IaC in this Day 5 folder provisions hosting infrastructure for it.

## The practical learning loop

**Learn the concept → inspect console → perform a small safe exercise → interpret output → troubleshoot → clean up → document verified results.** The individual lessons are not checklists alone; each explains the underlying service, how it fits a real system, concrete commands and what a successful or failed response means.

## Start with these three real labs

- [AWS fundamentals and access](aws/01-aws-fundamentals-access/README.md): account vs region vs AZ; Console vs CloudShell vs CLI vs SSH; run STS identity checks.
- [AWS EC2 website](aws/05-ec2-web-hosting/README.md): use SSH, install Nginx, inspect port 80 and serve a page.
- [GCP Compute Engine website](gcp/05-vm-web-hosting/README.md): connect using gcloud SSH, install Nginx, configure firewall and serve a page.

Then progress to [Terraform AWS EC2 app](terraform/06-aws/vpc-ec2-app/README.md) and [Terraform GCP Cloud Run app](terraform/07-gcp/cloud-run-app/README.md).

## Cost, access and security

- You need your own authorized AWS and Google Cloud accounts/projects to run real labs. These files do **not** connect to your accounts automatically.
- Check billing and set alerts **before** provisioning; alerts are not hard spending caps.
- Prefer MFA, least privilege, temporary CLI sessions and workload roles. Never commit `.pem`, service account JSON, `.tfstate`, `.tfvars` containing secrets, or tokens.
- For public web demos, expose only HTTP port 80 as needed; restrict SSH to your own IP or use managed access. Do not expose databases.
- Managed Kubernetes, load balancers, NAT and databases may be costly; their exercises can remain architecture-only until you choose to deploy.
- Always verify resources were deleted in the correct regions/projects and review billing afterward.

## Study schedule

This material is a **masterclass reference**, not a claim that dozens of substantial labs can be mastered in one calendar day. Follow the numbered lessons at your pace and record actual evidence as you go. Some labs are conceptual to avoid needless cloud charges.

## Evidence template

For each lab, document the objective, what you predicted, commands/console actions, redacted output, what it proves, errors, diagnosis and cleanup. Only mark a lab complete after verification. Do not paste cloud credentials or sensitive account identifiers into GitHub.

## Cloud-native DevOps expansion — 10 concepts

The AWS and GCP tracks now include **ten additional paired modules**: native IaC, source repositories, CI/CD, federated CI identity, configuration management, DevSecOps/governance, backup/recovery, release strategies, event-driven remediation, and GitOps. Each provider has its own lesson and lab; the Terraform Masterclass structure is unchanged.

- [AWS additional modules](aws/README.md#additional-cloud-native-devops-modules-10-concepts)
- [GCP additional modules](gcp/README.md#additional-cloud-native-devops-modules-10-concepts)

All new labs are documented examples, **not evidence of executed deployments**.
