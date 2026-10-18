# AWS Lab 01 — AWS foundations, identities and ways to connect

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **aws foundations, identities and ways to connect**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

An AWS account is a billing and security boundary. A Region is a geographic cluster of Availability Zones (AZs); an AZ is an isolated group of data centres. A VPC, EC2 instance and EBS volume are regional or zonal resources, whereas IAM is global. Region selection affects latency, data residency, availability and price.

### How this fits into a real system

AWS Management Console is a graphical client to AWS APIs. CloudShell is a browser terminal with AWS CLI and credentials from the signed-in identity. Your Ubuntu AWS CLI calls the same APIs from your laptop. SDKs call APIs from programs. SSH is different: it logs into a guest operating system on EC2, not into the AWS account.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: sign in using a non-root identity with MFA; use the region selector at the upper right; search for CloudShell and open it. In CloudShell run the commands below. On Ubuntu install AWS CLI v2 using AWS official instructions and prefer IAM Identity Center (`aws configure sso` and `aws sso login`) if your account supports it.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
aws --version
aws sts get-caller-identity
aws configure list
aws ec2 describe-regions --query "Regions[].RegionName" --output table
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

STS output contains UserId (principal identifier), Account (12-digit account ID), and Arn (resource identity, e.g. assumed role). Region commands may require EC2 read permissions. Do not paste real account identifiers into public documentation.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** `Unable to locate credentials` means the local CLI lacks usable authentication; check SSO login or the selected profile. `AccessDenied` means authentication succeeded but the policy does not allow the API. `Could not connect` suggests network/proxy/DNS.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** What is the difference between an AWS Region and AZ? Why does SSH access to an instance not give you AWS API permissions?

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
