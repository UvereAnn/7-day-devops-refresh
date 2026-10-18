# AWS Lab 03 — VPCs, subnets, routes and security boundaries

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **vpcs, subnets, routes and security boundaries**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

A VPC is an isolated virtual network with a CIDR range such as 10.20.0.0/16. A subnet is an AZ-specific portion, e.g. 10.20.1.0/24. Route tables decide where traffic goes; an Internet Gateway provides a route to/from the internet for eligible public-addressed resources. A subnet is public when its associated route table routes 0.0.0.0/0 to an Internet Gateway; a private subnet does not.

### How this fits into a real system

Security groups are stateful, instance/ENI-level allow rules; network ACLs are stateless subnet rules. Public reachability requires routing, a public IP, permitted security group traffic, and a listening application. A NAT Gateway permits outbound connections from private subnets but costs money.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: VPC → Your VPCs → Create VPC; choose VPC only, 10.20.0.0/16. Create subnet 10.20.1.0/24 in an AZ. Create and attach an Internet Gateway; add a 0.0.0.0/0 route to a route table and associate it with the subnet. Avoid overlapping CIDRs.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
aws ec2 describe-vpcs --query "Vpcs[].{Id:VpcId,Cidr:CidrBlock}" --output table
aws ec2 describe-subnets --query "Subnets[].{Id:SubnetId,Vpc:VpcId,AZ:AvailabilityZone}" --output table
aws ec2 describe-route-tables --output json
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

Confirm the subnet’s route table has the intended default route; a public subnet alone does not make an EC2 instance accessible unless it has a public address. Keep SSH limited to your own IP or use Session Manager.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** If an instance cannot reach the internet, inspect route table, public IP, security group egress, NACLs and DNS. A timeout is not the same as a DNS lookup failure.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** Explain how a public subnet differs from a private subnet. Why is an Internet Gateway not sufficient by itself?

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
