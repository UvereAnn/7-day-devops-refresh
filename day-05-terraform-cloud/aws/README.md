# AWS Cloud Engineering — Learn by Doing

This is a **teaching course**, not a checklist. Start with the concept explanation, follow the console walkthrough, run commands only in the specified environment, interpret their results, then troubleshoot and clean up. Every module is a guided lab; no cloud operation is claimed to have been performed on your behalf.

## Why this track matters

Cloud engineering involves **identity, networking, compute, storage, application delivery, observability and cost control**. We learn to operate these services manually before asking Terraform to automate them. We will use a disposable Nginx page first, then relate the lessons to our existing [`devops-cicd-lab`](https://github.com/UvereAnn/devops-cicd-lab) Node.js app.

## How to access resources

| Purpose | AWS approach | What it actually connects to |
|---|---|---|
| Graphical administration | AWS Management Console | Cloud service APIs |
| Browser terminal | AWS CloudShell | Cloud service APIs via CLI |
| Ubuntu terminal | AWS CLI / SDK | Cloud service APIs |
| VM login | SSH / EC2 Instance Connect | Linux OS on a VM |
| Private VM administration | Systems Manager Session Manager | Managed/private VM session when configured |
| Application access | Browser, `curl`, DNS, load balancer | Running HTTP service |

A login to a VM does **not** automatically authorize API calls; those require IAM and a workload identity/role.

## Guided learning modules

1. [AWS foundations, identities and ways to connect](01-aws-fundamentals-access/README.md)
2. [IAM identities, policies, roles and least privilege](02-iam-security/README.md)
3. [VPCs, subnets, routes and security boundaries](03-vpc-networking/README.md)
4. [EC2, AMIs, instance types and secure SSH](04-ec2-ssh/README.md)
5. [Host a real web page on EC2 with Nginx](05-ec2-web-hosting/README.md)
6. [S3 buckets, objects, versioning and lifecycle](06-s3-storage/README.md)
7. [EBS, EFS and filesystem persistence](07-ebs-efs/README.md)
8. [RDS, Aurora and DynamoDB](08-databases/README.md)
9. [ALB, target groups and Auto Scaling](09-load-balancing-autoscaling/README.md)
10. [Container registry and orchestrators](10-containers-ecr-ecs-eks/README.md)
11. [Lambda and API Gateway](11-lambda-api-gateway/README.md)
12. [DNS, Route 53 and CDN](12-route53-cloudfront/README.md)
13. [CloudWatch, CloudTrail and Systems Manager](13-monitoring-logging/README.md)
14. [SQS, SNS and EventBridge](14-messaging-events/README.md)
15. [KMS, Secrets Manager and credential handling](15-secrets-encryption/README.md)
16. [Systematic AWS failure diagnosis](16-troubleshooting/README.md)
17. [Cloud costs, budgets and teardown](17-billing-cleanup/README.md)

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

1. [Native infrastructure as code](18-native-iac/README.md) — Lab 18
2. [Cloud source repositories](19-source-repositories/README.md) — Lab 19
3. [Cloud-native CI/CD](20-cloud-native-cicd/README.md) — Lab 20
4. [Short-lived CI/CD credentials](21-federated-ci-auth/README.md) — Lab 21
5. [Configuration and fleet management](22-configuration-management/README.md) — Lab 22
6. [DevSecOps, policy and governance](23-devsecops-governance/README.md) — Lab 23
7. [Backup and disaster recovery](24-backup-disaster-recovery/README.md) — Lab 24
8. [Rolling, blue-green and canary releases](25-deployment-strategies/README.md) — Lab 25
9. [Event-driven operations and remediation](26-automated-operations/README.md) — Lab 26
10. [GitOps for Kubernetes](27-gitops/README.md) — Lab 27
