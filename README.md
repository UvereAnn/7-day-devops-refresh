# 🚀 7-Day DevOps Engineering Refresh

A hands-on DevOps engineering refresh covering **Linux, Networking, Git, CI/CD, Docker, Kubernetes, Terraform, Cloud, Observability, DevSecOps, GitOps, Troubleshooting, and Interview Preparation**.

This repository documents a structured **7-day practical DevOps refresh** designed to strengthen core concepts through hands-on exercises, troubleshooting scenarios, command-line practice, and interview-focused questions.

The goal is not simply to memorize commands or definitions, but to understand **how DevOps tools and concepts work together and how to troubleshoot real-world problems systematically**.

---

## 🎯 Objectives

By the end of this refresh, I aim to be able to:

- Explain major DevOps concepts clearly without relying on memorized definitions.
- Work confidently with Linux systems and networking fundamentals.
- Use Git and GitHub effectively for version control and collaboration.
- Understand and implement CI/CD workflows.
- Build, run, and troubleshoot containerized applications with Docker.
- Deploy and manage applications using Kubernetes.
- Provision infrastructure using Terraform.
- Understand core cloud infrastructure concepts and services.
- Monitor applications and infrastructure using observability tools.
- Understand DevSecOps and GitOps principles.
- Troubleshoot common infrastructure and application failures systematically.
- Explain technical decisions and troubleshooting approaches clearly during DevOps interviews.

---

## 🗓️ 7-Day Learning Roadmap

| Day | Focus | Key Topics |
| --- | --- | --- |
| **Day 1** | Linux & Networking | Linux filesystem, permissions, users, processes, services, logs, packages, environment variables, SSH, CPU, memory, disk, IP addresses, ports, TCP/UDP, DNS, HTTP/HTTPS, routing, firewalls, troubleshooting |
| **Day 2** | Git, GitHub & CI/CD | Git fundamentals, branches, merging, pull requests, GitHub workflows, CI/CD concepts, pipelines |
| **Day 3** | Docker | Images, containers, Dockerfiles, volumes, networks, registries, Docker Compose, troubleshooting |
| **Day 4** | Kubernetes | Pods, Deployments, Services, ConfigMaps, Secrets, namespaces, scaling, networking, troubleshooting |
| **Day 5** | Terraform & Cloud | Infrastructure as Code, Terraform workflow, providers, resources, variables, state, modules, cloud infrastructure |
| **Day 6** | Observability, DevSecOps & GitOps | Metrics, logs, monitoring, Prometheus, Grafana, security scanning, GitOps concepts and workflows |
| **Day 7** | Interview Preparation | DevOps interview questions, troubleshooting scenarios, project explanations, architecture discussions, mock interview |

---

## 📂 Repository Structure

```text
7-day-devops-refresh/
│
├── README.md
│
├── day-01-linux-networking/
│   └── README.md
│
├── day-02-git-cicd/
│   └── README.md
│
├── day-03-docker/
│   └── README.md
│
├── day-04-kubernetes/
│   └── README.md
│
├── day-05-terraform-cloud/
│   └── README.md
│
├── day-06-observability-devsecops-gitops/
│   └── README.md
│
└── day-07-interview-preparation/
    └── README.md
```

Each directory contains detailed notes, commands, practical exercises, troubleshooting scenarios, and interview questions for that day's topic.

---

## 🧠 Learning Approach

The refresh follows a simple engineering approach:

```text
Understand
    ↓
Practice
    ↓
Observe
    ↓
Troubleshoot
    ↓
Fix
    ↓
Verify
    ↓
Explain
```

Instead of memorizing commands, the focus is on understanding:

- **What problem does this tool solve?**
- **What does the command tell me?**
- **What evidence does the output provide?**
- **What should I investigate next?**
- **How do I verify that the problem has actually been fixed?**

---

## 🔍 Troubleshooting Mindset

A major focus of this repository is systematic troubleshooting.

The general approach used throughout the labs is:

```text
Observe
   ↓
Identify the symptom
   ↓
Gather evidence
   ↓
Form a hypothesis
   ↓
Test the hypothesis
   ↓
Identify the root cause
   ↓
Apply the appropriate fix
   ↓
Verify
```

The goal is to avoid randomly restarting services or changing configurations without first understanding the problem.

Examples of scenarios covered include:

- Application is not running
- Service keeps crashing
- Server is unreachable
- Port is not accessible
- DNS is not resolving
- Server has high CPU usage
- Server is running low on memory
- Filesystem is running out of disk space
- Application works locally but cannot be reached remotely
- CI/CD pipeline failures
- Container failures
- Kubernetes application failures

---

## 🛠️ Technologies & Tools

Throughout the refresh, I will work with technologies and tools including:

### Linux & Networking

`Linux` • `Bash` • `systemd` • `SSH` • `DNS` • `TCP/IP` • `HTTP/HTTPS`

### Version Control & CI/CD

`Git` • `GitHub` • `GitHub Actions` • `Jenkins`

### Containers & Orchestration

`Docker` • `Docker Compose` • `Kubernetes` • `Helm`

### Infrastructure & Cloud

`Terraform` • `AWS` • `GCP` • `OCI`

### Observability

`Prometheus` • `Grafana` • `CloudWatch` • `Cloud Monitoring`

### DevSecOps & GitOps

`Trivy` • `SonarCloud/SonarQube` • `Argo CD`

---

## 💻 Practical Learning

This repository is designed around hands-on practice rather than theory alone.

Examples include:

```bash
# Inspect Linux processes
ps aux
top

# Inspect system services
systemctl status <service>

# Investigate service logs
journalctl -u <service>

# Check disk usage
df -h
du -sh <directory>

# Check memory
free -h

# Inspect network interfaces
ip addr

# Inspect routing
ip route

# Inspect listening ports
ss -tuln

# Test DNS
dig example.com
nslookup example.com

# Test HTTP/HTTPS endpoints
curl -I https://example.com
```

Commands are used as **diagnostic tools**, not simply memorized as a list.

---

## 🧪 Troubleshooting Example

If an application is unavailable, the goal is not to immediately restart the server.

Instead:

```text
Is the server reachable?
        ↓
Is the application/service running?
        ↓
Is the expected port listening?
        ↓
Is the application bound to the correct interface?
        ↓
Does it respond locally?
        ↓
Are firewall/network rules allowing traffic?
        ↓
What do the application/service logs show?
        ↓
Identify and fix the root cause
        ↓
Verify the application
```

This same evidence-driven mindset can be applied across Linux, cloud infrastructure, containers, Kubernetes, and CI/CD.

---

## 🎤 Interview Preparation

Each section also includes interview-focused questions designed to help explain concepts naturally.

Examples include:

- What happens when you access a website?
- What is the difference between a process and a service?
- How would you troubleshoot an unreachable Linux server?
- How would you troubleshoot a service that keeps crashing?
- How would you investigate high CPU or memory usage?
- What is the difference between an image and a container?
- How does Kubernetes expose an application?
- How does a CI/CD pipeline work?
- How does Terraform manage infrastructure?
- How would you troubleshoot a failed deployment?

The focus is not just on knowing the answer, but being able to explain the **reasoning and troubleshooting process**.

---

## 💡 Key Principle

> **Don't guess. Observe, gather evidence, investigate, fix the root cause, and verify.**

This repository represents continuous hands-on practice aimed at strengthening practical DevOps engineering, troubleshooting, and technical communication skills.

---

## 📌 Repository Purpose

This repository serves as:

- A personal DevOps knowledge base
- A hands-on technical refresher
- A troubleshooting reference
- An interview preparation resource
- A record of practical DevOps learning and continuous improvement

The documentation can be revisited whenever a quick refresher on a DevOps concept, command, workflow, or troubleshooting approach is needed.

---

**Built through hands-on practice, troubleshooting, and continuous learning.**