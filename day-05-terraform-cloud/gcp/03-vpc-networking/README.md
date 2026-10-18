# GCP Lab 03 — Global VPCs, regional subnets and firewall rules

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **global vpcs, regional subnets and firewall rules**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

A Google Cloud VPC network is global; its subnets belong to regions. Firewall rules permit or deny traffic based on direction, priority, target and source. Routes determine next hops. Unlike AWS security groups, VPC firewall rules are evaluated at network level for matching instances.

### How this fits into a real system

An external IP plus permissive firewall rule does not guarantee service availability: the VM must listen on the correct address and port. Private Google access, Cloud NAT and VPC peering are separate networking concepts.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: VPC network → VPC networks → create a custom-mode VPC and a subnet in your chosen region. Examine firewall rules; for a demo HTTP server allow TCP/80 only to the intended target VM using network tags. Keep SSH limited or use IAP.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
gcloud compute networks list
gcloud compute networks subnets list
gcloud compute firewall-rules list --format="table(name,network,direction,allowed)"
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

Confirm subnet region and CIDR; distinguish firewall rule from VM network tags. Never add 0.0.0.0/0 ingress to SSH simply to make a lab work.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** Timeout? Check external IP, firewall priority, target tags, route and server socket. Connection refused? Host reachable but service not listening.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** How does a GCP VPC differ from an AWS VPC?

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
