# AWS Lab 02 — IAM identities, policies, roles and least privilege

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **iam identities, policies, roles and least privilege**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

IAM controls who can perform which AWS API action on which resource under what conditions. Authentication proves identity; authorization evaluates policies. Users are long-lived identities, roles supply temporary credentials to trusted principals, and policies describe permissions. An EC2 instance role avoids embedding access keys on a server.

### How this fits into a real system

Identity-based policies grant permissions to users/groups/roles; resource policies attach to supported resources such as S3 buckets. An explicit deny overrides allows. IAM Identity Center is a recommended human workforce access pattern; MFA protects sign-in. IAM itself is global but policies can restrict regions and resources.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: IAM → Roles → inspect an existing role’s trust policy and permissions; IAM → Policies → open a managed policy and read its JSON. Use the policy simulator when authorized. Do not create AdministratorAccess credentials for a lab.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
aws sts get-caller-identity
aws iam list-roles --max-items 5 --query "Roles[].RoleName" --output table
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

A trust policy answers who may assume a role; a permissions policy answers what the assumed role may do. Listing roles may fail if your identity lacks `iam:ListRoles`; that is an authorization result, not proof that IAM is broken.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** If a user can sign in but cannot list S3 buckets, inspect attached policies, permissions boundaries, organization SCPs and explicit denies. For an EC2 app, attach a scoped instance profile rather than storing secrets in code.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** Why prefer roles over static access keys? Explain least privilege and explicit deny.

**Answer framework:** Define the relevant services first; explain the request/data flow; identify the security boundary; describe a command or console screen you would use to verify the claim; finish with a failure mode or trade-off. Practice saying this aloud without reading.

## Verify and document your result

- [ ] I can explain the concept in my own words.
- [ ] I located the service in the console and identified the region/project.
- [ ] I ran or safely inspected the example commands.
- [ ] I recorded actual output and explained what it proves.
- [ ] I can diagnose the scenario above.
- [ ] I checked for and removed temporary billable resources.

### Lab notes (fill in after practice)

| Item | Your verified observation |
|---|---|
| Date and region/zone | |
| Identity type (never secret values) | |
| Resources created | |
| Commands run and result | |
| Failure and diagnosis | |
| Cleanup confirmed | |

## Where to learn more

- [AWS official documentation](https://docs.aws.amazon.com/)
- [Pricing and cost information](https://aws.amazon.com/pricing/)

**Next lesson:** Return to [AWS track overview](../README.md) to follow the modules in order.
