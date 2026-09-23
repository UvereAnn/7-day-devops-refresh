# Day 1 — Linux, Networking & Troubleshooting

## Overview

Day 1 focuses on the Linux and networking fundamentals required for DevOps, Cloud, Platform Engineering, and infrastructure troubleshooting.

The goal is not to memorize Linux commands.

The goal is to understand:

- What the operating system is doing
- How applications run on Linux
- How permissions and ownership work
- How services are managed
- How to inspect logs
- How CPU, memory, and disk affect applications
- How machines communicate over networks
- How DNS, ports, TCP/UDP, HTTP/HTTPS, routing, and firewalls work together
- How to systematically troubleshoot infrastructure problems

---

# Table of Contents

1. [Linux Filesystem](#1-linux-filesystem)
2. [Working with Files and Directories](#2-working-with-files-and-directories)
3. [Reading and Searching Files](#3-reading-and-searching-files)
4. [Linux Permissions](#4-linux-permissions)
5. [Users, Groups and Ownership](#5-users-groups-and-ownership)
6. [Processes](#6-processes)
7. [Services and systemd](#7-services-and-systemd)
8. [Linux Logs](#8-linux-logs)
9. [Package Management](#9-package-management)
10. [Environment Variables](#10-environment-variables)
11. [SSH](#11-ssh)
12. [Disk Usage](#12-disk-usage)
13. [Memory](#13-memory)
14. [CPU](#14-cpu)
15. [Networking Fundamentals](#15-networking-fundamentals)
16. [IP Addresses](#16-ip-addresses)
17. [Localhost](#17-localhost)
18. [Ports](#18-ports)
19. [TCP vs UDP](#19-tcp-vs-udp)
20. [DNS](#20-dns)
21. [HTTP and HTTPS](#21-http-and-https)
22. [Routing](#22-routing)
23. [Firewalls](#23-firewalls)
24. [Important Networking Commands](#24-important-networking-commands)
25. [Troubleshooting Methodology](#25-troubleshooting-methodology)
26. [Troubleshooting Labs](#26-troubleshooting-labs)
27. [Interview Questions](#27-interview-questions)
28. [Command Cheat Sheet](#28-command-cheat-sheet)
29. [Key Takeaways](#29-key-takeaways)

---

# 1. Linux Filesystem

Linux organizes files and directories in a hierarchical structure.

The top of the filesystem is:

```text
/
```

This is called the **root directory**.

It should not be confused with:

```text
/root
```

`/root` is the home directory of the `root` user.

## Important directories

| Directory | Purpose |
| --- | --- |
| `/` | Top of the Linux filesystem |
| `/home` | Home directories for regular users |
| `/root` | Home directory for the root user |
| `/etc` | System and application configuration |
| `/var` | Variable data |
| `/var/log` | System/application logs |
| `/tmp` | Temporary files |
| `/usr` | User-space programs, libraries and resources |
| `/opt` | Optional/third-party software |
| `/bin` | Essential command binaries |
| `/dev` | Device files |
| `/proc` | Runtime information about processes/kernel |
| `/mnt` | Common location for mounted filesystems |

Example:

```text
/
├── etc/
├── home/
│   └── user/
├── root/
├── tmp/
├── usr/
└── var/
    └── log/
```

## Important distinction

```text
/       = filesystem root

/root   = root user's home directory
```

---

# 2. Working with Files and Directories

## Print current directory

```bash
pwd
```

Example:

```text
/home/user
```

---

## List files

```bash
ls
```

Detailed listing:

```bash
ls -l
```

Include hidden files:

```bash
ls -la
```

---

## Change directory

```bash
cd /var/log
```

Return home:

```bash
cd ~
```

Move up one directory:

```bash
cd ..
```

---

## Create a directory

```bash
mkdir practice
```

Create nested directories:

```bash
mkdir -p app/logs
```

---

## Create a file

```bash
touch app.log
```

---

## Copy

```bash
cp source.txt destination.txt
```

Copy a directory recursively:

```bash
cp -r source-directory destination-directory
```

---

## Move or rename

```bash
mv old.txt new.txt
```

Move a file:

```bash
mv app.log logs/
```

---

## Remove a file

```bash
rm file.txt
```

Remove a directory recursively:

```bash
rm -r directory
```

Be careful with `rm`, especially when using elevated privileges.

---

# 3. Reading and Searching Files

## `cat`

Print a file:

```bash
cat app.log
```

Best for relatively small files.

---

## `less`

Read a file interactively:

```bash
less app.log
```

Useful for larger files.

Press:

```text
q
```

to quit.

---

## `head`

Display the beginning of a file:

```bash
head app.log
```

By default, it displays the first 10 lines.

Example:

```bash
head -5 app.log
```

displays the first five lines.

---

## `tail`

Display the end of a file:

```bash
tail app.log
```

Follow new log entries in real time:

```bash
tail -f app.log
```

This is particularly useful when troubleshooting applications.

---

## `grep`

Search for text:

```bash
grep ERROR app.log
```

Example:

```bash
grep "connection failed" app.log
```

Combine commands using pipes:

```bash
ps aux | grep nginx
```

The pipe:

```text
|
```

takes the output of the command on the left and passes it to the command on the right.

---

## `find`

Search for files/directories.

Example:

```bash
find /var/log -name "*.log"
```

Search the current directory:

```bash
find . -name "app.conf"
```

---

## Output redirection

Overwrite/create a file:

```bash
echo "Application started" > app.log
```

Append:

```bash
echo "Database connected" >> app.log
```

Difference:

```text
>   overwrite
>>  append
```

---

# 4. Linux Permissions

Linux permissions determine **who can do what to a file or directory**.

Inspect permissions:

```bash
ls -l
```

Example:

```text
-rwxr-xr-x deploy.sh
```

The permissions are divided into:

```text
owner | group | others
```

Linux uses:

```text
r = read
w = write
x = execute
```

---

## Numeric permissions

Each permission has a numeric value:

```text
r = 4
w = 2
x = 1
```

Therefore:

| Number | Permission |
| ---: | --- |
| 7 | `rwx` |
| 6 | `rw-` |
| 5 | `r-x` |
| 4 | `r--` |
| 3 | `-wx` |
| 2 | `-w-` |
| 1 | `--x` |
| 0 | `---` |

---

## `chmod 755`

```bash
chmod 755 deploy.sh
```

means:

```text
Owner  → rwx
Group  → r-x
Others → r-x
```

Result:

```text
-rwxr-xr-x
```

Often appropriate for an executable script.

---

## `chmod 644`

```bash
chmod 644 app.conf
```

means:

```text
Owner  → rw-
Group  → r--
Others → r--
```

Result:

```text
-rw-r--r--
```

Often used for ordinary non-secret configuration files.

Sensitive configuration containing credentials may require more restrictive permissions.

---

## Add execute permission

```bash
chmod +x deploy.sh
```

Without execute permission:

```bash
./deploy.sh
```

may result in:

```text
Permission denied
```

---

# 5. Users, Groups and Ownership

Linux uses users and groups to control access to resources.

## Current user

```bash
whoami
```

---

## User and group information

```bash
id
```

Example information includes:

```text
uid
gid
groups
```

---

## Groups

```bash
groups
```

Groups allow multiple users to share permissions without configuring every user individually.

---

## Ownership

A file has:

```text
Owner
Group
Others
```

Example:

```text
-rw-r----- root developers app.log
```

Here:

```text
Owner = root
Group = developers
```

The owner does **not** necessarily mean the person who originally created the file forever; ownership can be changed.

---

## Change ownership

```bash
sudo chown user:group file
```

Example:

```bash
sudo chown appuser:developers app.log
```

---

## DevOps mental model

When you encounter:

```text
Permission denied
```

ask:

> **Who is doing what to which resource, and does that user/group have permission?**

---

# 6. Processes

A **process** is a running instance of a program.

Examples include:

```text
Chrome
Python application
nginx
dockerd
PostgreSQL
```

---

## View processes

```bash
ps
```

More detailed:

```bash
ps aux
```

Important columns include:

| Column | Meaning |
| --- | --- |
| `USER` | User running the process |
| `PID` | Process ID |
| `%CPU` | CPU usage |
| `%MEM` | Memory usage |
| `COMMAND` | Program/command |

---

## Search processes

```bash
ps aux | grep chrome
```

---

## Real-time monitoring

```bash
top
```

`top` displays processes and resource usage dynamically.

Press:

```text
q
```

to exit.

---

## Stop a process

Graceful termination:

```bash
kill PID
```

Equivalent to requesting `SIGTERM` by default.

Explicitly:

```bash
kill -15 PID
```

Verify:

```bash
ps -p PID
```

If the process refuses to terminate and force is genuinely required:

```bash
kill -9 PID
```

`SIGKILL` should generally not be the first troubleshooting action because it does not allow the process to shut down gracefully.

---

## Process troubleshooting principle

Do not immediately run:

```bash
kill -9 PID
```

Instead:

```text
Observe
   ↓
Identify process
   ↓
Investigate
   ↓
Take appropriate action
   ↓
Verify
```

---

# 7. Services and systemd

A **service** commonly refers to functionality provided by a background application and managed by a service manager such as `systemd`.

A **process** is a running program.

A **daemon** is a program designed to run in the background.

Example:

```text
docker.service
      ↓
managed by systemd
      ↓
dockerd
      ↓
running process
```

---

## Common service categories

| Category | Examples |
| --- | --- |
| Web servers | nginx, Apache |
| Databases | PostgreSQL, MySQL |
| Remote access | SSH |
| Containers | Docker, containerd |
| Networking | NetworkManager, systemd-resolved |
| Scheduling | cron |
| Logging | systemd-journald, rsyslog |
| Monitoring | Prometheus exporters |
| Security | firewall/security services |

---

## Check service status

```bash
systemctl status docker
```

Example:

```text
Active: active (running)
```

means the service is running.

---

## Start

```bash
sudo systemctl start docker
```

---

## Stop

```bash
sudo systemctl stop docker
```

---

## Restart

```bash
sudo systemctl restart docker
```

---

## Enable at boot

```bash
sudo systemctl enable docker
```

---

## Disable automatic startup

```bash
sudo systemctl disable docker
```

Important distinction:

```text
start/stop       → current state

enable/disable   → automatic startup behavior at boot
```

A service can therefore be:

```text
running + disabled
```

or:

```text
stopped + enabled
```

---

## List services

Loaded service units:

```bash
systemctl list-units --type=service
```

Installed service unit files:

```bash
systemctl list-unit-files --type=service
```

---

# 8. Linux Logs

Logs provide evidence about what applications and systems are doing.

Common location:

```text
/var/log
```

---

## Application log example

```text
INFO Application started
INFO Database connected
ERROR Database connection failed
INFO Retrying connection
ERROR Connection timeout
```

Search errors:

```bash
grep ERROR app.log
```

Follow the log:

```bash
tail -f app.log
```

---

## systemd logs

`journalctl` reads logs collected by the systemd journal.

View journal:

```bash
journalctl
```

Logs for a specific service:

```bash
journalctl -u docker
```

Recent service logs:

```bash
journalctl -u docker -n 50
```

For troubleshooting a failed service:

```bash
systemctl status myapp
journalctl -u myapp -n 50
```

Do not repeatedly restart a failing service without investigating why it is failing.

---

# 9. Package Management

Ubuntu commonly uses APT for package management.

---

## Refresh package information

```bash
sudo apt update
```

This updates the local package index.

It does **not** mean all installed software has been upgraded.

---

## Upgrade installed packages

```bash
sudo apt upgrade
```

---

## Install

```bash
sudo apt install curl
```

---

## Remove

```bash
sudo apt remove package-name
```

---

## Search

```bash
apt search nginx
```

---

## Check installed packages

```bash
apt list --installed
```

Filter:

```bash
apt list --installed 2>/dev/null | grep nginx
```

---

## Find executable

```bash
which curl
```

Example:

```text
/usr/bin/curl
```

This tells us which executable would be run when we type `curl`.

---

# 10. Environment Variables

Environment variables allow configuration to be separated from application code.

Examples:

```bash
APP_ENV=production
DATABASE_HOST=db.example.com
PORT=8080
```

Instead of changing application code for every environment:

```text
Development → DATABASE_HOST=localhost
Testing     → DATABASE_HOST=test-db
Production  → DATABASE_HOST=prod-db
```

the application can read configuration from its environment.

---

## Common environment variables

```bash
echo $USER
echo $HOME
echo $PATH
```

`PATH` contains directories that the shell searches for executable commands.

For example:

```bash
which git
```

might return:

```text
/usr/bin/git
```

because `/usr/bin` is available through the command search path.

---

## Create/export a variable

Shell variable:

```bash
DEVOPS_ENV=production
```

Use it:

```bash
echo $DEVOPS_ENV
```

Export to child processes:

```bash
export DEVOPS_ENV=production
```

Check:

```bash
printenv DEVOPS_ENV
```

---

## Persistent configuration

Common files include:

```text
~/.bashrc
~/.profile
```

Reload Bash configuration:

```bash
source ~/.bashrc
```

---

## Security

Environment variables help avoid hardcoding configuration and credentials directly into source code.

However:

> **Environment variables are not automatically a secure secrets-management solution.**

Never commit passwords, API keys, private keys, or credential-containing `.env` files to a public Git repository.

---

# 11. SSH

SSH stands for **Secure Shell**.

It is commonly used to securely administer remote Linux systems.

SSH normally uses:

```text
TCP port 22
```

---

## Connect

```bash
ssh username@server-ip
```

Example:

```bash
ssh ubuntu@203.0.113.10
```

---

## SSH keys

SSH commonly uses public-key authentication.

```text
Client                         Server

Private key                    Public key
Keep secret                    Stored/authorized here
     │
     └──── authentication ─────►
```

Generate a key pair:

```bash
ssh-keygen
```

Common location:

```text
~/.ssh/
```

Example:

```text
id_ed25519       ← private
id_ed25519.pub   ← public
```

**Never expose or commit the private key.**

---

## AWS EC2 example

```bash
ssh -i my-key.pem ubuntu@SERVER_IP
```

Here:

```text
ssh          → SSH client
-i           → specify identity/private key
my-key.pem   → private key
ubuntu       → remote username
SERVER_IP    → destination
```

---

## SSH troubleshooting

If SSH fails, investigate:

```text
Correct IP/hostname?
        ↓
Network path/reachability?
        ↓
TCP port 22 reachable?
        ↓
Firewall/security group?
        ↓
Routing?
        ↓
SSH service running?
        ↓
Correct username?
        ↓
Correct private key?
```

Useful distinction:

```text
Connection timeout
        ↓
Often investigate network/firewall/port/path

Permission denied (publickey)
        ↓
SSH server was reached
        ↓
Investigate username/key/authentication
```

A failed `ping` alone does not prove that SSH is unavailable because ICMP may be blocked.

---

# 12. Disk Usage

Disk is persistent storage used for:

- Files
- Logs
- Databases
- Application data
- Container images
- Backups

---

## Check filesystem usage

```bash
df -h
```

Important columns:

```text
Size
Used
Avail
Use%
Mounted on
```

Example:

```text
Filesystem  Size  Used  Avail  Use%  Mounted on
/dev/sda1   100G   98G     2G   98%  /
```

---

## Investigate what consumes disk space

```bash
du -sh /directory
```

Example:

```bash
du -sh ~/Downloads
```

Inspect directories:

```bash
du -sh ~/* 2>/dev/null
```

Mental model:

```text
df → How full is the filesystem?

du → What is consuming space?
```

---

# 13. Memory

RAM is temporary working memory used by running processes.

Check memory:

```bash
free -h
```

Typical fields:

```text
total
used
free
buff/cache
available
```

Do not look only at `free`.

Linux can use otherwise-unused RAM for caches, so `available` is often a more useful indicator of memory that can be made available to applications.

---

## Find memory-consuming processes

```bash
top
```

or:

```bash
ps aux
```

---

# 14. CPU

CPU usage can be inspected with:

```bash
top
```

and:

```bash
ps aux
```

Important:

```text
%CPU
```

indicates process CPU usage.

If a server is slow:

```text
Observe CPU usage
        ↓
Identify process consuming CPU
        ↓
Investigate process/application
        ↓
Inspect relevant logs
        ↓
Determine root cause
        ↓
Take appropriate action
        ↓
Verify
```

High CPU is a **symptom**, not automatically the root cause.

Do not immediately kill the process without understanding why it is consuming CPU.

---

# 15. Networking Fundamentals

Networking allows machines and applications to communicate.

Important concepts:

```text
IP address
Ports
TCP/UDP
DNS
HTTP/HTTPS
localhost
Routing
Firewall
SSH
```

These concepts work together rather than independently.

---

# 16. IP Addresses

An IP address identifies a network interface/destination so network traffic can be routed appropriately.

Inspect interfaces:

```bash
ip addr
```

Short form:

```bash
ip a
```

Example:

```text
inet 192.168.1.167/24
```

`192.168.x.x` belongs to a private IPv4 address range.

A machine may have multiple network interfaces, such as:

```text
lo    → loopback
eno1  → Ethernet
wlo1  → Wi-Fi
```

Example:

```text
wlo1
state UP
inet 192.168.1.167/24
```

indicates an active Wi-Fi interface with an IPv4 address.

---

# 17. Localhost

The loopback IPv4 address is:

```text
127.0.0.1
```

It represents the local machine.

The hostname:

```text
localhost
```

normally resolves to a loopback address.

Example:

```text
http://127.0.0.1:8080
```

means connect to port 8080 on the same machine.

---

## Binding matters

Application listening on:

```text
127.0.0.1:8080
```

means it accepts IPv4 connections only through the local loopback interface.

Remote machines cannot directly reach that listener.

Application listening on:

```text
0.0.0.0:8080
```

means it is listening on all IPv4 interfaces.

Important:

> `0.0.0.0` does not automatically mean the application is publicly accessible.

Routing, NAT, firewall rules, cloud security controls, and other network configuration still determine reachability.

---

# 18. Ports

An IP address identifies the host/network destination.

A port identifies a network endpoint associated with an application/service on that host.

Analogy:

```text
IP address = building address
Port       = particular door
```

Example:

```text
192.168.1.50:8080
```

contains:

```text
192.168.1.50 → IP address
8080         → port
```

Common ports:

| Service | Port |
| --- | ---: |
| SSH | 22 |
| DNS | 53 |
| HTTP | 80 |
| HTTPS | 443 |
| PostgreSQL | 5432 |
| Redis | 6379 |

---

## Inspect listening ports

```bash
ss -tuln
```

Options:

```text
-t → TCP
-u → UDP
-l → listening
-n → numerical addresses/ports
```

Show processes as well:

```bash
sudo ss -tulpn
```

---

# 19. TCP vs UDP

## TCP

TCP is connection-oriented and provides reliable, ordered delivery.

Examples commonly using TCP include:

```text
SSH
HTTP/1.1
HTTP/2
HTTPS using HTTP/1.1 or HTTP/2
```

Common ports:

```text
SSH   → TCP 22
HTTP  → TCP 80
HTTPS → TCP 443
```

---

## UDP

UDP is connectionless and does not itself provide TCP's retransmission and ordered-delivery guarantees.

It has less protocol overhead.

DNS commonly uses UDP for ordinary queries, although DNS can also use TCP.

Example:

```text
DNS → UDP 53 or TCP 53 depending on the situation
```

---

# 20. DNS

DNS stands for **Domain Name System**.

It allows names such as:

```text
github.com
```

to resolve to IP addresses.

Simplified:

```text
github.com
    ↓
DNS lookup
    ↓
IP address
```

---

## `nslookup`

```bash
nslookup github.com
```

Example:

```text
Name: github.com
Address: 140.x.x.x
```

---

## `dig`

```bash
dig github.com
```

Important sections include:

```text
status
QUESTION SECTION
ANSWER SECTION
SERVER
```

Successful query:

```text
status: NOERROR
```

---

## Important DNS records

```text
A      → hostname to IPv4 address
AAAA   → hostname to IPv6 address
CNAME  → hostname alias pointing to another hostname
```

Example:

```text
example.com
     ↓ A
203.0.113.20
```

---

## DNS troubleshooting

If:

```bash
ping -c 4 8.8.8.8
```

works but hostname resolution fails, basic IP connectivity may be working while DNS is failing.

Investigate with:

```bash
dig example.com
nslookup example.com
```

---

# 21. HTTP and HTTPS

HTTP is an application-layer protocol used for communication between web clients and servers.

Common default port:

```text
HTTP → TCP 80
```

HTTPS protects HTTP communication using TLS.

Common default:

```text
HTTPS → TCP 443
```

TLS provides security properties including encryption and server authentication through certificates.

---

## `curl`

`curl` can send requests to URLs and is very useful for testing HTTP/HTTPS endpoints.

Example:

```bash
curl https://example.com
```

Inspect response headers:

```bash
curl -I https://example.com
```

Example response:

```text
HTTP/2 200
```

---

## Common HTTP status codes

| Code | Meaning |
| ---: | --- |
| 200 | OK |
| 301 | Permanent redirect |
| 302 | Redirect |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Internal Server Error |
| 502 | Bad Gateway |
| 503 | Service Unavailable |

---

## What happens when you access a website?

Suppose you enter:

```text
https://example.com
```

A simplified flow is:

```text
URL entered
    ↓
DNS resolves hostname
    ↓
Destination IP obtained
    ↓
Operating system determines route
    ↓
Network connection established
    ↓
TCP connection to port 443
    ↓
TLS handshake
    ↓
Secure connection established
    ↓
HTTP request
    ↓
Server processes request
    ↓
HTTP response
    ↓
Browser processes response
    ↓
Page rendered
```

This is the standard HTTP/1.1 or HTTP/2 over TLS model.

Modern HTTP/3 uses QUIC over UDP, so not every modern HTTPS connection necessarily uses TCP.

---

# 22. Routing

Routing determines where network packets should be sent.

Inspect Linux routing:

```bash
ip route
```

Example:

```text
default via 192.168.1.1 dev wlo1
192.168.1.0/24 dev wlo1
```

The default route means:

> If there is no more specific matching route, send traffic toward the default gateway.

Simplified:

```text
Laptop
   ↓
Default gateway
   ↓
Other networks
   ↓
Destination
```

---

# 23. Firewalls

A firewall controls network traffic according to rules.

Example:

```text
22    SSH
80    HTTP
443   HTTPS
5432  PostgreSQL
```

A server might permit:

```text
80/443 → public traffic
22     → restricted administrative sources
5432   → private/internal access only
```

---

## Ubuntu UFW

Check status:

```bash
sudo ufw status
```

Example:

```text
Status: inactive
```

This means UFW itself is not currently enforcing firewall rules.

It does not necessarily prove that no network filtering exists elsewhere.

---

## Cloud environments

For an AWS-hosted application, traffic may encounter:

```text
Internet/client
      ↓
Cloud networking/security controls
      ↓
Operating-system firewall
      ↓
Network interface
      ↓
Listening port
      ↓
Application
```

Therefore:

> **Application running does not automatically mean application reachable.**

---

## SSH security note

Avoid unnecessarily exposing SSH to:

```text
0.0.0.0/0
```

because that represents every IPv4 source.

Prefer restricting administrative access to the appropriate trusted source/range where practical.

---

# 24. Important Networking Commands

## Network interfaces/IP addresses

```bash
ip a
```

---

## Routing

```bash
ip route
```

---

## Listening sockets

```bash
ss -tuln
```

Processes associated with sockets:

```bash
sudo ss -tulpn
```

---

## Basic reachability

```bash
ping -c 4 8.8.8.8
```

Hostname:

```bash
ping -c 4 example.com
```

Important:

> A failed `ping` does not prove that the server/application is down.

`ping` uses ICMP, which may be filtered while application traffic remains available.

---

## DNS

```bash
dig example.com
```

```bash
nslookup example.com
```

---

## HTTP/HTTPS

```bash
curl -I https://example.com
```

---

# 25. Troubleshooting Methodology

One of the most important lessons from Day 1:

> **Do not guess. Gather evidence.**

Use:

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
Identify root cause
   ↓
Fix
   ↓
Verify
```

Avoid:

```text
Problem
   ↓
Random restart
   ↓
Random configuration changes
   ↓
Hope
```

---

# 26. Troubleshooting Labs

## Scenario 1 — Server has no disk space

Problem:

```text
Filesystem 98% full
```

### Step 1 — Confirm

```bash
df -h
```

Determine which filesystem/mount is full.

### Step 2 — Investigate consumption

```bash
du -sh /path/*
```

or inspect likely directories.

### Step 3 — Identify cause

Potential causes include:

- Logs
- Application data
- Temporary files
- Container data
- Database data
- Backups
- Unexpected file growth

### Step 4 — Safely remediate

Depending on the actual cause:

- Clean appropriate temporary data
- Rotate/archive logs
- Move appropriate data
- Increase storage where justified
- Fix the process causing abnormal growth

Do not randomly delete large files.

### Step 5 — Verify

```bash
df -h
```

---

## Scenario 2 — Application isn't running

Check:

```bash
systemctl status myapp
```

Suppose:

```text
Active: failed
```

Next:

```bash
journalctl -u myapp -n 50
```

Investigate the actual error.

Potential causes may include:

- Invalid configuration
- Missing dependency
- Permission problem
- Port conflict
- Unavailable dependency
- Resource exhaustion

Fix the identified root cause.

Then, when appropriate:

```bash
sudo systemctl restart myapp
systemctl status myapp
```

Finally test the application.

---

## Scenario 3 — Port 8080 isn't accessible

Application:

```text
Active: active (running)
```

but users cannot reach port `8080`.

### Step 1

Check whether the port is listening:

```bash
sudo ss -tulpn | grep :8080
```

Possible result:

```text
127.0.0.1:8080
```

The application is only listening on loopback.

Or:

```text
0.0.0.0:8080
```

The application is listening on all IPv4 interfaces.

### Step 2

Test locally:

```bash
curl http://localhost:8080
```

If local access works but remote access fails, investigate:

- Binding address
- Host firewall
- Cloud security rules
- Routing/network path
- Load balancer/proxy configuration if applicable

### Step 3

Test remotely from an appropriate client:

```bash
curl http://SERVER_IP:8080
```

---

## Scenario 4 — DNS isn't resolving

Test:

```bash
nslookup myapp.com
```

or:

```bash
dig myapp.com
```

If DNS fails, investigate the appropriate DNS records and resolver configuration.

Test basic connectivity separately when useful:

```bash
ping -c 4 8.8.8.8
```

This helps distinguish:

```text
Network connectivity issue
```

from:

```text
DNS resolution issue
```

---

## Scenario 5 — High CPU

Start with:

```bash
top
```

or:

```bash
ps aux
```

Identify the process consuming CPU.

Do not immediately:

```bash
kill -9 PID
```

Instead:

```text
Identify process
     ↓
Understand what application it belongs to
     ↓
Inspect behavior/logs
     ↓
Find root cause
     ↓
Take appropriate action
     ↓
Verify CPU usage
```

---

## Scenario 6 — Service keeps crashing

Check:

```bash
systemctl status myapp
```

Then:

```bash
journalctl -u myapp -n 50
```

If it repeatedly crashes after restart, repeatedly restarting it is not the solution.

Investigate why.

Possible areas:

- Configuration
- Permissions
- Dependencies
- Resource exhaustion
- Port conflicts
- Application errors

Fix the root cause and verify.

---

## Scenario 7 — Server unreachable

Suppose:

```bash
ssh ubuntu@SERVER_IP
```

fails.

Troubleshoot:

```text
Correct IP/hostname?
       ↓
Network path/reachability?
       ↓
TCP port 22 reachable?
       ↓
Routing correct?
       ↓
Cloud security rules?
       ↓
Host firewall?
       ↓
SSH service running?
       ↓
Correct username?
       ↓
Correct key?
```

Do not rely solely on `ping`.

A host may ignore ICMP while SSH remains available.

---

# 27. Interview Questions

## Q1. What is the difference between a process and a service?

**Answer:**

A process is a running instance of a program. A service generally provides some background functionality and is commonly managed by a service manager such as `systemd`. A service itself may consist of one or more processes.

For example, `docker.service` can be managed by systemd while the Docker daemon runs as the `dockerd` process.

---

## Q2. How would you check whether Docker is running?

```bash
systemctl status docker
```

If it is failing, inspect its logs:

```bash
journalctl -u docker
```

Then troubleshoot based on the actual error rather than immediately restarting the machine.

---

## Q3. What is the difference between `apt update` and `apt upgrade`?

**Answer:**

`apt update` refreshes the local package index so the system knows which package versions are available.

`apt upgrade` upgrades installed packages based on the available package information.

---

## Q4. Why use environment variables?

**Answer:**

Environment variables separate configuration from application code. This makes the same application easier to run across development, testing, and production without changing the source code.

They can also help avoid hardcoding credentials into source code, although environment variables themselves should not automatically be considered secure secret storage.

---

## Q5. How would you troubleshoot an unreachable server?

**Answer:**

I would first verify that I am using the correct IP address or hostname. Then I would investigate network reachability and whether the required application port is reachable.

For SSH, I would verify TCP port 22, routing, host firewall rules, cloud security rules, and whether the SSH service is running. If network connectivity is working, I would verify the username and authentication key.

I would not rely solely on `ping` because ICMP may be blocked even when the server's application ports are reachable.

---

## Q6. What happens when you access a website?

**Answer:**

When I enter a URL, the hostname first needs to be resolved to an IP address using DNS.

The operating system then determines the network route toward the destination.

For a typical HTTPS connection using HTTP/1.1 or HTTP/2, the client establishes a TCP connection to the server, normally on port 443.

A TLS handshake establishes a secure connection and authenticates the server.

The browser sends an HTTP request, the server processes it and returns an HTTP response containing a status code, headers, and potentially content.

The browser then processes the response and renders the webpage.

---

## Q7. Application is running but port 8080 isn't accessible. What do you do?

**Answer:**

First, I would verify whether the application is actually listening on port 8080:

```bash
sudo ss -tulpn | grep :8080
```

I would check the binding address to determine whether it is listening only on `127.0.0.1` or on an externally reachable interface.

I would then test locally:

```bash
curl http://localhost:8080
```

If the application works locally but not remotely, I would investigate firewall rules, cloud security controls, routing, and other relevant network components.

After fixing the identified issue, I would test the endpoint again.

---

## Q8. What is the difference between `df` and `du`?

**Answer:**

```text
df → filesystem-level disk usage

du → space consumed by files/directories
```

I might use `df -h` to identify which filesystem is nearly full and then use `du` to investigate which directories are consuming space.

---

## Q9. How would you investigate high CPU?

**Answer:**

I would start with:

```bash
top
```

or:

```bash
ps aux
```

to identify the process consuming CPU.

Then I would determine which application owns that process, inspect its logs and behavior, identify the root cause, take the appropriate corrective action, and verify that CPU usage has returned to an expected level.

---

## Q10. Why might an application work on localhost but not remotely?

**Answer:**

The application may be bound only to:

```text
127.0.0.1
```

which means it accepts connections only through the local loopback interface.

It may need to listen on an appropriate network interface for remote access.

Even then, firewall rules, routing, NAT, cloud security controls, and other networking configuration can still affect reachability.

---

# 28. Command Cheat Sheet

## Filesystem

```bash
pwd
ls
ls -l
ls -la
cd
mkdir
mkdir -p
touch
cp
mv
rm
find
```

## Files/logs

```bash
cat file
less file
head file
tail file
tail -f file
grep "text" file
```

## Permissions/users

```bash
chmod
chown
whoami
id
groups
```

## Processes

```bash
ps
ps aux
top
kill PID
kill -9 PID
```

## Services

```bash
systemctl status service
sudo systemctl start service
sudo systemctl stop service
sudo systemctl restart service
sudo systemctl enable service
sudo systemctl disable service
```

## Logs

```bash
journalctl
journalctl -u service
journalctl -u service -n 50
```

## Packages

```bash
sudo apt update
sudo apt upgrade
sudo apt install package
sudo apt remove package
apt search package
which command
```

## Environment

```bash
echo $HOME
echo $USER
echo $PATH
export NAME=value
printenv NAME
```

## Disk

```bash
df -h
du -sh directory
```

## Memory

```bash
free -h
top
```

## Networking

```bash
ip a
ip route
ss -tuln
sudo ss -tulpn
ping -c 4 HOST
dig DOMAIN
nslookup DOMAIN
curl URL
curl -I URL
```

## SSH

```bash
ssh user@server
ssh -i key.pem user@server
```

---

# 29. Key Takeaways

### Linux

```text
Filesystem   → Where resources live
Permissions  → Who can access them
Processes    → What is running
Services     → How background applications are managed
Logs         → Evidence of what happened
CPU/RAM      → Runtime resources
Disk         → Persistent storage
```

### Networking

```text
IP        → Network destination/address
Port      → Application/service endpoint
DNS       → Name resolution
TCP/UDP   → Transport
Routing   → Where traffic goes
Firewall  → Which traffic is allowed
HTTP      → Web communication
TLS       → Secure encrypted communication
SSH       → Secure remote administration
```

### Troubleshooting

Always remember:

```text
Observe
   ↓
Gather evidence
   ↓
Identify the failing layer
   ↓
Investigate
   ↓
Fix the root cause
   ↓
Verify
```

> **Do not guess. Do not randomly restart things. Follow the evidence.**

---

# Day 1 Completion Checklist

## Linux

- [x] Filesystem
- [x] Files and directories
- [x] Permissions
- [x] Users and groups
- [x] Processes
- [x] Services and systemd
- [x] Logs
- [x] Package management
- [x] Environment variables
- [x] SSH
- [x] Disk
- [x] Memory
- [x] CPU

## Networking

- [x] IP addresses
- [x] Ports
- [x] TCP/UDP
- [x] DNS
- [x] HTTP/HTTPS
- [x] localhost
- [x] Routing
- [x] Firewall
- [x] SSH

## Commands

- [x] `ls`
- [x] `cd`
- [x] `pwd`
- [x] `cp`
- [x] `mv`
- [x] `rm`
- [x] `cat`
- [x] `less`
- [x] `grep`
- [x] `find`
- [x] `chmod`
- [x] `chown`
- [x] `ps`
- [x] `top`
- [x] `free`
- [x] `df`
- [x] `du`
- [x] `systemctl`
- [x] `journalctl`
- [x] `ss`
- [x] `curl`
- [x] `ping`
- [x] `dig`
- [x] `nslookup`
- [x] `ip`

## Troubleshooting

- [x] Server has no disk space
- [x] Application isn't running
- [x] Port 8080 isn't accessible
- [x] DNS isn't resolving
- [x] Server has high CPU
- [x] Service keeps crashing
- [x] Server is unreachable

---

## Day 1 Complete ✅

**Next: Day 2 — Git, GitHub & CI/CD**