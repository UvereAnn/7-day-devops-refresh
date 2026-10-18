# GCP Lab 01 — GCP resource hierarchy, projects and access

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **gcp resource hierarchy, projects and access**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

Google Cloud organizes resources under organizations, folders and projects. Projects are the main administrative and billing boundary for many services. Regions contain zones; Compute Engine VMs are zonal, while VPC networks are global and subnets are regional. APIs often need enabling per project.

### How this fits into a real system

Google Cloud Console is a browser UI; Cloud Shell is a managed browser terminal; gcloud is the local CLI; client libraries are programmatic. Browser SSH and `gcloud compute ssh` connect to VM operating systems. `gcloud auth login` establishes CLI user credentials, while Application Default Credentials serve many local SDKs and Terraform use cases.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: select your project from the top project selector; check Billing linkage and IAM. Open Cloud Shell and run identity and project commands. On Ubuntu install Google Cloud CLI using official instructions; run `gcloud init` for local configuration.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
gcloud --version
gcloud auth list
gcloud config list
gcloud projects list
gcloud services list --enabled --project YOUR_PROJECT_ID
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

`gcloud config list` displays active project and region/zone if configured. Being authenticated does not imply permission to use every service. Do not publish project numbers or sensitive identifiers unnecessarily.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** `PERMISSION_DENIED` means an IAM/API policy issue; `API has not been used` suggests service activation; `project not found` may mean wrong ID or access.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** How do Google Cloud projects compare to AWS accounts? How do Cloud Shell and local gcloud differ?

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

- [GCP official documentation](https://cloud.google.com/docs)
- [Pricing and cost information](https://cloud.google.com/pricing)

**Next lesson:** Return to [GCP track overview](../README.md) to follow the modules in order.
