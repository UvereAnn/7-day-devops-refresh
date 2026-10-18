# AWS Lab 09 — ALB, target groups and Auto Scaling

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **alb, target groups and auto scaling**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

An Application Load Balancer (ALB) routes HTTP(S) traffic to healthy targets based on listener rules; a target group defines backend instances/IPs and health checks. An Auto Scaling group manages desired/min/max EC2 instance counts.

### How this fits into a real system

Health checks distinguish a running VM from a healthy application. A 502 can indicate backend connection issues; a 503 can indicate no healthy targets. ALBs, NAT and multiple instances incur ongoing charges.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: EC2 → Load Balancers → review wizard fields without creating a resource; inspect listeners, target groups, health-check path `/health`, target port and security groups. Explore EC2 → Auto Scaling Groups and launch templates.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
aws elbv2 describe-load-balancers --query "LoadBalancers[].LoadBalancerName" --output table
aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[].AutoScalingGroupName" --output table
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

If nothing exists, expect empty output. Draw the intended request path: browser → ALB:443 → target group:3000 → application `/health`.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** When health checks fail, test `/health` locally, confirm process binding and port, inspect target SG from ALB SG, health check path and grace periods.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** How does ALB differ from NLB? What triggers scaling?

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
