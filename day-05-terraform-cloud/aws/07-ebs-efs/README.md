# AWS Lab 07 — EBS, EFS and filesystem persistence

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **ebs, efs and filesystem persistence**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

EBS is block storage attached to EC2, typically within one AZ; it behaves like a disk. EFS is a managed shared network filesystem that multiple Linux instances can mount, with regional architecture. Instance store is ephemeral and tied to instance lifetime.

### How this fits into a real system

Choose EBS for boot volumes and single-instance filesystems; EFS for shared POSIX files across hosts; S3 for objects. Snapshots provide point-in-time backups of EBS volumes and cost money.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: EC2 → Instances → select your lab VM → Storage → inspect root EBS volume and size. EC2 → Volumes → identify the volume; EC2 → Snapshots → inspect available snapshot options. Do not detach a running root disk.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
lsblk
df -hT
findmnt /
# AWS CLI from laptop:
aws ec2 describe-volumes --query "Volumes[].{Id:VolumeId,Size:Size,AZ:AvailabilityZone}" --output table
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

`lsblk` shows block devices and `df -hT` shows mounted filesystems. A volume can exist without being mounted; resizing a volume and growing its filesystem are distinct operations.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** A full disk can break deployments despite free CPU. Inspect `df -h`, `du -sh /var/log/*`, `lsblk` and filesystem errors. Delete unused snapshots and volumes only after checking they are not needed.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** When should you use S3 vs EBS vs EFS?

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
