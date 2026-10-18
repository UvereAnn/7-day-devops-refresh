# AWS Lab 05 — Host a real web page on EC2 with Nginx

> **Course status:** Teaching material and guided practice. The exercises are **not claimed to have been executed**. Read before provisioning; costs and UI labels may change.

## What you will understand

By the end, you should be able to explain **host a real web page on ec2 with nginx**, identify its purpose in a cloud architecture, use the relevant console or CLI, and diagnose at least one failure without guessing.

## Lesson 1 — The underlying concepts

A web server listens on a TCP port and responds to HTTP requests. Nginx serves static files from `/var/www/html` by default on Ubuntu. Your browser connects to the EC2 public IP on TCP/80, which requires an inbound HTTP security-group rule. SSH on TCP/22 is for administration, not web traffic.

### How this fits into a real system

The request path is browser → internet → IGW → instance public IP → security group → Nginx. `curl localhost` proves the service works locally; accessing the public IP tests network reachability as well. For production, prefer HTTPS, domain names, and limited exposure.

**Mental model:** Cloud consoles and CLIs send authenticated API requests to a provider. A resource must exist, your identity must be authorized, and the network and application must also be correctly configured. Do not confuse those layers. In our ongoing `devops-cicd-lab` project, these skills eventually help us host, secure, observe and automate the same Node.js service.

## Lesson 2 — Guided console walkthrough

Connect to your Ubuntu EC2 over SSH. In EC2 console add inbound TCP/80 from 0.0.0.0/0 only for this intentionally public demo page. Execute the commands below on EC2, then open http://EC2_PUBLIC_IP in your local browser.

**Before clicking Create:** Check the selected account/project, region, service pricing, permissions and intended cleanup. Keep the default private settings unless the lab explicitly requires public HTTP access. Record what you chose and why.

## Lesson 3 — Commands and explanations

Replace uppercase placeholders with your own values. Run commands on your laptop, CloudShell or VM as specified; they are not interchangeable.

```bash
sudo apt update
sudo apt install -y nginx
printf "<h1>My AWS EC2 lab</h1>\n" | sudo tee /var/www/html/index.html
sudo systemctl enable --now nginx
sudo systemctl status nginx --no-pager
curl -I http://localhost
sudo ss -tlnp | grep :80
```

**How to read the commands:** The first token is the program (`aws`, `gcloud`, `ssh`, `curl`, `sudo`, etc.). Subsequent words select a service/subcommand or set flags. `--query` (AWS) filters API JSON output using JMESPath; `--format` (gcloud) selects display format. `curl` tests HTTP; `systemctl` manages Linux services; `ss` inspects listening sockets. Do not execute a command on your laptop if it is intended to run inside a VM.

### Expected observation and interpretation

Expect `HTTP/1.1 200 OK` locally. From Ubuntu laptop: `curl -I http://EC2_PUBLIC_IP`. If local works but remote fails, check SG, public IP, routes and host firewall. If local fails, inspect Nginx service and logs.

A successful command is evidence only for the specific layer it tested. For example, a healthy local web server does not prove public internet reachability. When a command returns no resources, that may be an entirely valid result.

## Lesson 4 — Troubleshooting lab

**Symptom and diagnosis:** `sudo journalctl -u nginx -n 30 --no-pager` and `sudo nginx -t` check service/config. `ss -tlnp` confirms port binding. After practice terminate the instance and delete unneeded EBS volumes, security groups and VPC resources.

Use this investigation order: **identity → account/project and region → permissions → resource status → networking → OS/process → application logs**. Change one variable at a time and rerun the failing check. Keep the original error message in your private lab notes (redact IDs, keys and secrets before publishing).

## Interview practice

**Question:** Explain how you would diagnose “Nginx works on localhost but not from my browser.”

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
