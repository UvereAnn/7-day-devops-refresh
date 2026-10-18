# GCP Lab 18 — GCP billing, budgets and cleanup

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **gcp billing, budgets and cleanup**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

Compute VMs, persistent disks, static IPs, Cloud SQL, GKE, load balancers and storage can incur ongoing charges. Stopping a VM can leave disk charges. Budgets notify but are not hard spending limits.

### How this fits into a real system

Resources are project- and region/zone-scoped. A project can contain services you forgot about; verify all resources before deletion. Some retained storage and logs may continue costing money.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: Billing → Budgets & alerts → set an alert. Review Cost table. Delete disposable VM, reserved IPs, disks, Cloud Run services, Artifact Registry images/repositories, buckets and other lab resources only after verifying they are no longer needed.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
gcloud compute instances list
gcloud compute disks list
gcloud run services list --region=YOUR_REGION
gcloud artifacts repositories list --location=YOUR_REGION
gcloud storage buckets list
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

No results in one region does not guarantee zero spend; use Billing reports and inspect other regions/projects.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** If a bill continues, inspect storage, networking, Cloud SQL, cluster resources, logs, data egress and project selection.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** What continues charging after a VM is stopped or deleted?

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
