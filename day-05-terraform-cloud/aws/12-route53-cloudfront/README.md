# AWS Lab 12 — DNS, Route 53 and CDN

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **dns, route 53 and cdn**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

DNS maps names to records such as A, AAAA and CNAME. Route 53 manages DNS zones and routing policies. CloudFront caches content at edge locations and can front S3 or HTTP origins; HTTPS certificates and cache invalidation matter.

### How this fits into a real system

Buying a domain and creating a hosted zone are separate billing actions. A CloudFront distribution may incur traffic and request costs. For learning, inspect existing DNS without buying a domain.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Console: Route 53 → Hosted zones → inspect hosted zone concept; CloudFront → Distributions → inspect origins and behaviors. On Ubuntu query a public example domain to see DNS responses.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
dig example.com A
nslookup example.com
curl -I https://example.com
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

`dig` reports DNS records; `curl -I` tests HTTP headers over HTTPS. Successful DNS resolution does not guarantee a reachable web server.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** DNS failure: check nameservers, zone delegation, record type, TTL and resolver; CDN failure: check origin reachability, TLS, behavior rules and caching.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** What is the difference between DNS and CDN? Why might a DNS change take time?

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
