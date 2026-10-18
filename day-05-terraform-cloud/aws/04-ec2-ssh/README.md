# AWS Lab 04 — EC2, AMIs, instance types and secure SSH

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **ec2, amis, instance types and secure ssh**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

EC2 is a virtual machine service. An AMI supplies the OS image; instance type defines CPU and RAM; EBS is block storage. EC2 charges can accrue while instances run, and EBS storage can continue charging after termination. SSH uses a key pair to authenticate to the Linux operating system.

### How this fits into a real system

For an Ubuntu AMI the default username is commonly `ubuntu`. The private key stays on your laptop; AWS stores the public key. Security group TCP/22 should be restricted to your public IP, never broadly exposed for convenience. EC2 Instance Connect and Systems Manager Session Manager are alternatives when configured.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: EC2 → Launch instance → Ubuntu LTS AMI → affordable instance type → key pair → existing public subnet → auto-assign public IP → allow SSH from My IP. Confirm pricing and instance status checks. Download key once and keep it private.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
chmod 400 ~/Downloads/aws-lab.pem
ssh -i ~/Downloads/aws-lab.pem ubuntu@EC2_PUBLIC_IP
# On the instance:
whoami
hostname
ip route
exit
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

`whoami` should return `ubuntu` for a typical Ubuntu AMI. Public IP can change after stop/start unless a persistent address is assigned. `Permission denied (publickey)` means wrong username/key or missing public key; `Connection timed out` suggests networking/security-group issues.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** Check instance state and status checks; inspect public IP, subnet route, SG inbound SSH from your IP, NACL, correct username, and key permissions. Never commit `.pem` files.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** What happens to an instance public IP on stop/start? Distinguish connection refused, timed out and public-key denial.

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
