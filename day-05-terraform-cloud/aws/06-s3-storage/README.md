# AWS Lab 06 — S3 buckets, objects, versioning and lifecycle

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **s3 buckets, objects, versioning and lifecycle**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

Amazon S3 stores objects identified by keys inside globally unique bucket names. It is object storage, not a mounted block disk. Bucket region affects placement; versioning preserves prior versions and can increase storage cost. IAM and bucket policies control access; Block Public Access should remain enabled for private labs.

### How this fits into a real system

S3 is commonly used for artifacts, backups, static assets and Terraform remote state. Encryption at rest is available; do not confuse a private object with a publicly accessible website. Object storage requests, storage and data transfer can incur costs.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: S3 → Create bucket → unique name and desired region → keep Block Public Access on. Upload a harmless text file, inspect its properties, enable versioning, upload an edited version and inspect versions. Use CLI with your chosen bucket name.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
printf "S3 lab version one\n" > s3-lab.txt
aws s3 cp s3-lab.txt s3://YOUR_UNIQUE_BUCKET_NAME/
aws s3 ls s3://YOUR_UNIQUE_BUCKET_NAME/
aws s3 cp s3://YOUR_UNIQUE_BUCKET_NAME/s3-lab.txt downloaded.txt
cat downloaded.txt
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

You should see the object key in `aws s3 ls` and the same text after download. A 403 may indicate bucket policy, IAM, KMS or organization policy; a 404 may mean the key is wrong.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** Check region, exact bucket name, identity (`aws sts get-caller-identity`), `s3:PutObject`/`s3:GetObject`, and encryption permissions. To delete a versioned bucket, remove all object versions and delete markers first.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** How does S3 differ from EBS? What happens when versioning is enabled?

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
