# 🐧 Day 1 — Linux, Networking & Troubleshooting

> A comprehensive practical refresher for Linux administration, networking fundamentals, system troubleshooting, and DevOps interview preparation.

---

# 📚 Table of Contents

## Part I — Linux Foundations

1. [Linux and the Operating System](#1-linux-and-the-operating-system)
2. [Linux Filesystem](#2-linux-filesystem)
3. [Paths and Navigation](#3-paths-and-navigation)
4. [Files and Directories](#4-files-and-directories)
5. [Reading, Searching and Manipulating Text](#5-reading-searching-and-manipulating-text)
6. [Pipes and Redirection](#6-pipes-and-redirection)
7. [Permissions](#7-linux-permissions)
8. [Users, Groups and Ownership](#8-users-groups-and-ownership)
9. [Processes](#9-processes)
10. [Signals and Process Termination](#10-signals-and-process-termination)
11. [Services, Daemons and systemd](#11-services-daemons-and-systemd)
12. [Linux Logs](#12-linux-logs)
13. [Package Management](#13-package-management)
14. [Environment Variables](#14-environment-variables)
15. [SSH](#15-ssh)
16. [Disk](#16-disk)
17. [Memory](#17-memory)
18. [CPU](#18-cpu)

## Part II — Networking

19. [Networking Mental Model](#19-networking-mental-model)
20. [Network Interfaces](#20-network-interfaces)
21. [IP Addresses](#21-ip-addresses)
22. [Localhost and Loopback](#22-localhost-and-loopback)
23. [CIDR Basics](#23-cidr-basics)
24. [Ports and Sockets](#24-ports-and-sockets)
25. [TCP vs UDP](#25-tcp-vs-udp)
26. [DNS](#26-dns)
27. [HTTP and HTTPS](#27-http-and-https)
28. [TLS](#28-tls)
29. [Routing and Default Gateway](#29-routing-and-default-gateway)
30. [Firewalls and Cloud Security Rules](#30-firewalls-and-cloud-security-rules)
31. [What Happens When You Visit a Website?](#31-what-happens-when-you-visit-a-website)

## Part III — Troubleshooting

32. [Troubleshooting Methodology](#32-troubleshooting-methodology)
33. [Disk Full](#33-troubleshooting-disk-full)
34. [High CPU](#34-troubleshooting-high-cpu)
35. [Memory Problems](#35-troubleshooting-memory-problems)
36. [Application Not Running](#36-troubleshooting-an-application-that-is-not-running)
37. [Service Keeps Crashing](#37-troubleshooting-a-service-that-keeps-crashing)
38. [Port 8080 Not Accessible](#38-troubleshooting-port-8080-not-accessible)
39. [DNS Failure](#39-troubleshooting-dns-failure)
40. [Server/SSH Unreachable](#40-troubleshooting-an-unreachable-server)

## Part IV — Interview & Revision

41. [Interview Questions](#41-interview-questions)
42. [Revision Quiz](#42-revision-quiz)
43. [Command Reference](#43-command-reference)
44. [Day 1 Mental Model](#44-day-1-mental-model)

---

# PART I — LINUX FOUNDATIONS

# 1. Linux and the Operating System

Linux is an operating-system family built around the Linux kernel.

For DevOps engineers, Linux is important because a huge amount of infrastructure runs on Linux:

- Cloud virtual machines
- Web servers
- Application servers
- Containers
- Kubernetes nodes
- CI/CD runners
- Databases
- Monitoring systems
- Automation servers

Understanding Linux therefore means understanding the environment in which many production applications actually run.

---

## Kernel

The **kernel** is the core of the operating system.

It manages resources such as:

```text
CPU
Memory
Processes
Devices
Filesystems
Networking
```

Applications do not directly control hardware. They interact with the operating system, which uses the kernel to manage the underlying resources.

Simplified:

```text
Applications
     ↓
Operating System / System Calls
     ↓
Linux Kernel
     ↓
CPU / RAM / Disk / Network / Devices
```

---

## Shell

A shell is a program that accepts commands and interacts with the operating system.

A common Linux shell is:

```text
Bash
```

When you type:

```bash
ls
```

the shell interprets your command and runs the appropriate program.

---

## Terminal vs Shell

These terms are related but different.

**Terminal:** The interface/window through which you interact with the command line.

**Shell:** The program interpreting your commands.

For example:

```text
Terminal
   ↓
Bash
   ↓
Linux
```

---

# 2. Linux Filesystem

Linux organizes files and directories in a hierarchy.

The top of that hierarchy is:

```text
/
```

This is called the **root directory**.

Everything exists somewhere underneath `/`.

Example:

```text
/
├── etc/
├── home/
├── root/
├── tmp/
├── usr/
├── var/
└── opt/
```

---

## `/` vs `/root`

This is an important distinction.

```text
/
```

means:

> The top/root of the entire filesystem.

But:

```text
/root
```

means:

> The home directory belonging to the `root` user.

Therefore:

```text
/       ≠       /root
```

---

## Important Linux directories

| Directory | Purpose |
|---|---|
| `/` | Root of the entire filesystem |
| `/home` | Home directories for normal users |
| `/root` | Root user's home directory |
| `/etc` | System/application configuration |
| `/var` | Variable application/system data |
| `/var/log` | System/application logs |
| `/tmp` | Temporary files |
| `/usr` | Programs, libraries and resources |
| `/opt` | Optional/third-party applications |
| `/dev` | Device representations |
| `/proc` | Runtime process/kernel information |
| `/mnt` | Common mount location |

For DevOps work, some especially important locations are:

```text
/etc
/var/log
/home
/tmp
/opt
```

---

# 3. Paths and Navigation

A **path** tells Linux where a resource exists.

There are two important kinds:

```text
Absolute path
Relative path
```

---

## Absolute path

An absolute path starts from `/`.

Example:

```text
/home/ann/app/config/app.conf
```

Because it starts with `/`, Linux knows exactly where to begin.

---

## Relative path

A relative path starts from your current location.

Suppose you are currently inside:

```text
/home/ann/app
```

Then:

```text
config/app.conf
```

is a relative path to:

```text
/home/ann/app/config/app.conf
```

---

## Current directory

```bash
pwd
```

means:

```text
Print Working Directory
```

Example:

```bash
pwd
```

might return:

```text
/home/ann
```

---

## Change directory

```bash
cd /var/log
```

Go home:

```bash
cd ~
```

Move one level upward:

```bash
cd ..
```

Current directory:

```text
.
```

Parent directory:

```text
..
```

---

# 4. Files and Directories

## List files

```bash
ls
```

Detailed listing:

```bash
ls -l
```

Show hidden files:

```bash
ls -a
```

Detailed + hidden:

```bash
ls -la
```

---

## Hidden files

Linux filenames beginning with `.` are normally hidden from a basic `ls`.

Examples:

```text
.bashrc
.profile
.git
.env
```

Use:

```bash
ls -la
```

to display them.

---

## Create directory

```bash
mkdir project
```

Create nested directories:

```bash
mkdir -p app/logs
```

`-p` allows parent directories to be created when necessary.

---

## Create empty file

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
cp -r source destination
```

---

## Move

```bash
mv file.txt /tmp/
```

`mv` can also rename files:

```bash
mv old-name.txt new-name.txt
```

---

## Remove

File:

```bash
rm file.txt
```

Directory and contents:

```bash
rm -r directory
```

Be careful.

Linux does not treat `rm` like moving something into a desktop recycle bin.

---

# 5. Reading, Searching and Manipulating Text

Text processing is extremely important in DevOps because:

```text
Logs are text
Configuration is often text
Command output is text
CI/CD output is text
```

---

## `cat`

Display file contents:

```bash
cat app.log
```

Useful for smaller files.

---

## `less`

For larger files:

```bash
less app.log
```

You can scroll through the file.

Press:

```text
q
```

to quit.

---

## `head`

Display beginning of file:

```bash
head app.log
```

Default:

```text
first 10 lines
```

First five:

```bash
head -5 app.log
```

---

## `tail`

Display end:

```bash
tail app.log
```

Follow new entries:

```bash
tail -f app.log
```

This is especially useful with application logs.

---

## `grep`

Search for matching text:

```bash
grep ERROR app.log
```

Example:

```text
INFO Application started
INFO Database connected
ERROR Database connection failed
INFO Retrying connection
ERROR Connection timeout
```

Running:

```bash
grep ERROR app.log
```

returns:

```text
ERROR Database connection failed
ERROR Connection timeout
```

---

## `find`

Find files/directories:

```bash
find . -name "app.conf"
```

Example:

```bash
find /var/log -name "*.log"
```

---

# 6. Pipes and Redirection

These are fundamental Linux concepts.

---

## Pipe `|`

A pipe sends output from one command into another.

Example:

```bash
ps aux | grep chrome
```

Conceptually:

```text
ps aux
   ↓
all process information
   ↓
|
   ↓
grep chrome
   ↓
only matching lines
```

This allows small Linux commands to be combined into powerful workflows.

---

## `>` — overwrite

```bash
echo "INFO Application started" > app.log
```

This writes to the file.

If the file already contains data, the existing content is overwritten.

---

## `>>` — append

```bash
echo "INFO Database connected" >> app.log
```

This adds content to the end.

---

## Practical example

```bash
echo "INFO Application started" > app.log
echo "INFO Database connected" >> app.log
echo "ERROR Database connection failed" >> app.log
echo "INFO Retrying connection" >> app.log
echo "ERROR Connection timeout" >> app.log
```

Then:

```bash
cat app.log
```

and:

```bash
grep ERROR app.log
```

This is a simple example of how application logs can be investigated.

---

# 7. Linux Permissions

This is one of the most important Linux topics.

Linux permissions answer:

> **Who can do what to this resource?**

There are three basic permissions:

```text
r = read
w = write
x = execute
```

And three permission categories:

```text
User/Owner
Group
Others
```

---

# Understanding `ls -l`

Run:

```bash
ls -l
```

You may see:

```text
-rwxr-xr-- 1 ann developers 200 Sep 20 10:00 deploy.sh
```

Focus on:

```text
-rwxr-xr--
```

Break it apart:

```text
- | rwx | r-x | r--
    │     │     │
    │     │     └── Others
    │     └──────── Group
    └────────────── Owner
```

The very first character describes the file type.

Common examples:

```text
- = regular file
d = directory
l = symbolic link
```

So:

```text
-rwxr-xr--
```

means:

```text
-    regular file
rwx  owner permissions
r-x  group permissions
r--  others permissions
```

---

## Alphabetic / symbolic notation

Permissions can be represented using letters.

```text
r = read
w = write
x = execute
- = permission absent
```

Example:

```text
rwx
```

means:

```text
read + write + execute
```

Example:

```text
r-x
```

means:

```text
read + execute
no write
```

Example:

```text
rw-
```

means:

```text
read + write
no execute
```

---

# Numeric / Octal Permission Notation

Linux permissions can also be represented numerically.

Values:

```text
Read    r = 4
Write   w = 2
Execute x = 1
```

You add them together.

---

## All combinations

| Numeric | Symbolic | Calculation |
|---:|---|---|
| 0 | `---` | 0 |
| 1 | `--x` | 1 |
| 2 | `-w-` | 2 |
| 3 | `-wx` | 2 + 1 |
| 4 | `r--` | 4 |
| 5 | `r-x` | 4 + 1 |
| 6 | `rw-` | 4 + 2 |
| 7 | `rwx` | 4 + 2 + 1 |

This table is worth understanding rather than memorizing blindly.

---

# Understanding `755`

Suppose:

```bash
chmod 755 deploy.sh
```

Break it down:

```text
7       5       5
│       │       │
Owner   Group   Others
```

Owner:

```text
7 = 4 + 2 + 1
  = r + w + x
  = rwx
```

Group:

```text
5 = 4 + 1
  = r + x
  = r-x
```

Others:

```text
5 = r-x
```

Therefore:

```text
755 = rwxr-xr-x
```

---

# Understanding `644`

```bash
chmod 644 app.conf
```

Owner:

```text
6 = 4 + 2
  = rw-
```

Group:

```text
4 = r--
```

Others:

```text
4 = r--
```

Therefore:

```text
644 = rw-r--r--
```

---

# Understanding `750`

Suppose:

```text
-rwxr-x---
```

Calculate:

Owner:

```text
rwx
4 + 2 + 1
= 7
```

Group:

```text
r-x
4 + 1
= 5
```

Others:

```text
---
= 0
```

Therefore:

```text
750
```

---

# Understanding `600`

```bash
chmod 600 secret.txt
```

means:

```text
Owner  = rw-
Group  = ---
Others = ---
```

This is more restrictive than `644`.

---

# Understanding `700`

```bash
chmod 700 private-script.sh
```

means:

```text
Owner  = rwx
Group  = ---
Others = ---
```

---

# Symbolic chmod notation

You do not always have to use numbers.

Linux also supports symbolic changes.

Categories:

```text
u = user/owner
g = group
o = others
a = all
```

Operations:

```text
+ = add permission
- = remove permission
= = set exact permission
```

---

## Add execute permission for owner

```bash
chmod u+x deploy.sh
```

---

## Add execute for everyone

```bash
chmod a+x deploy.sh
```

---

## Remove write from group

```bash
chmod g-w file.txt
```

---

## Remove read from others

```bash
chmod o-r file.txt
```

---

## Set owner permissions exactly

```bash
chmod u=rw file.txt
```

---

# File vs Directory Permissions

`r`, `w`, and `x` have slightly different practical meanings for directories.

## File

For a file:

```text
r → read contents
w → modify contents
x → execute file as a program/script
```

## Directory

For a directory:

```text
r → list directory entries
w → create/delete/rename entries, subject to related permissions
x → enter/traverse/access items through the directory
```

That is why directories commonly need `x` permission to be usable.

---

# Permission Troubleshooting

Suppose:

```bash
./deploy.sh
```

returns:

```text
Permission denied
```

Check:

```bash
ls -l deploy.sh
```

Suppose:

```text
-rw-r--r-- deploy.sh
```

There is no `x`.

Fix if the script should be executable:

```bash
chmod +x deploy.sh
```

Then verify:

```bash
ls -l deploy.sh
```

---

# 8. Users, Groups and Ownership

Permissions make more sense when combined with ownership.

Every file normally has:

```text
Owner
Group
```

Check:

```bash
ls -l
```

Example:

```text
-rw-r----- 1 root developers app.log
```

This means:

```text
Owner = root
Group = developers
```

Permissions:

```text
Owner  → rw-
Group  → r--
Others → ---
```

---

## Who am I?

```bash
whoami
```

---

## User identity

```bash
id
```

This displays information such as:

```text
UID
GID
Groups
```

---

## Groups

```bash
groups
```

A user can belong to multiple groups.

Groups allow permissions to be shared among users.

Instead of individually configuring access for ten developers, for example, they can belong to an appropriate group.

---

## Change ownership

```bash
sudo chown user file
```

Owner + group:

```bash
sudo chown user:group file
```

Example:

```bash
sudo chown ann:developers app.log
```

---

## Change group

```bash
sudo chgrp developers app.log
```

---

## Important mental model

When Linux says:

```text
Permission denied
```

ask:

```text
1. Which user is performing the action?
2. Which resource are they accessing?
3. Who owns the resource?
4. Which group owns it?
5. Which groups does the user belong to?
6. What permissions exist?
7. What action is being attempted?
```

In short:

> **Who is doing what to which resource, and are they allowed to do it?**

---

# 9. Processes

A **process** is a running instance of a program.

For example:

```text
Chrome installed on disk
        ↓
Start Chrome
        ↓
One or more Chrome processes run
```

Processes consume resources such as:

```text
CPU
RAM
File handles
Network connections
```

---

## PID

Every process has a:

```text
PID = Process ID
```

The PID identifies a running process.

---

## View processes

```bash
ps
```

More detailed:

```bash
ps aux
```

Important fields:

```text
USER
PID
%CPU
%MEM
COMMAND
```

---

## Search for process

```bash
ps aux | grep chrome
```

You may see many Chrome processes because modern browsers commonly use multiple processes.

For example:

```text
browser process
renderer processes
GPU process
utility processes
```

This is why:

```bash
ps aux | grep chrome
```

does not necessarily show only one process.

---

## `top`

```bash
top
```

provides live process and resource information.

Useful fields include:

```text
PID
USER
%CPU
%MEM
COMMAND
```

Press:

```text
q
```

to exit.

---

## CPU idle

In `top`, you may see:

```text
id
```

under CPU statistics.

`id` means:

```text
idle
```

A high idle percentage generally means the CPU has substantial unused capacity at that moment.

---

# 10. Signals and Process Termination

Linux can send **signals** to processes.

Two important ones are:

```text
SIGTERM
SIGKILL
```

---

## Graceful termination

```bash
kill PID
```

normally sends:

```text
SIGTERM
```

which is signal 15.

Explicitly:

```bash
kill -15 PID
```

SIGTERM asks the application to terminate and gives it an opportunity to perform cleanup.

---

## Force termination

```bash
kill -9 PID
```

sends:

```text
SIGKILL
```

The kernel terminates the process without allowing normal graceful shutdown handling.

---

## Why not immediately `kill -9`?

Because the application may need to:

```text
finish writes
close connections
release resources
clean temporary state
```

Better approach:

```text
Try graceful termination
        ↓
Verify
        ↓
If genuinely stuck
        ↓
Investigate
        ↓
Use force only when necessary
```

---

## Verify process

```bash
ps -p PID
```

---

## Process by name

```bash
pkill process-name
```

Be careful because matching by name may affect multiple processes.

---

# 11. Services, Daemons and systemd

These three terms are related but different.

## Process

A running program.

## Daemon

A program designed to run in the background.

## Service

Functionality commonly managed by a service manager.

On many modern Linux distributions, that service manager is:

```text
systemd
```

---

## Example: Docker

```text
systemd
   ↓
docker.service
   ↓
dockerd
   ↓
Docker daemon process
```

---

## Service status

```bash
systemctl status docker
```

You might see:

```text
Loaded: loaded
Active: active (running)
Main PID: 1234 (dockerd)
```

Interpretation:

```text
Loaded
→ systemd knows about the unit

Active: active (running)
→ currently running

Main PID
→ primary process
```

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

## Enable

```bash
sudo systemctl enable docker
```

This configures automatic startup at boot according to the unit's setup.

---

## Disable

```bash
sudo systemctl disable docker
```

---

# Stop vs Disable

These are NOT the same.

```text
STOP
↓
Change current runtime state

DISABLE
↓
Change automatic boot/startup behavior
```

Therefore:

```text
running + disabled
```

is possible.

And:

```text
stopped + enabled
```

is also possible.

---

## Docker socket activation

When Docker was stopped during practice, systemd indicated that:

```text
docker.socket
```

was still active.

A socket unit can be used for **socket activation**.

Conceptually:

```text
Request arrives at socket
        ↓
systemd notices request
        ↓
corresponding service can be activated
```

This explains why stopping a service may not always be the entire story when associated socket units exist.

---

## List services

Running/loaded service units:

```bash
systemctl list-units --type=service
```

Installed service unit files:

```bash
systemctl list-unit-files --type=service
```

---

## Common services

Examples:

```text
nginx             → web server
apache2           → web server
postgresql        → database
mysql             → database
ssh               → remote access
docker            → containers
containerd        → container runtime
cron              → scheduled jobs
systemd-resolved  → name resolution
```

---

# 12. Linux Logs

Logs are one of the most important troubleshooting sources.

They answer:

```text
What happened?
When?
What error occurred?
What was the application doing?
```

Common location:

```text
/var/log
```

---

## Example application log

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

Follow new logs:

```bash
tail -f app.log
```

---

# journalctl

Systems using systemd commonly store logs in the systemd journal.

View logs:

```bash
journalctl
```

Specific service:

```bash
journalctl -u docker
```

Last 50:

```bash
journalctl -u docker -n 50
```

---

## Troubleshooting a failed service

Suppose:

```bash
systemctl status myapp
```

shows:

```text
Active: failed
```

Your next move should usually involve evidence:

```bash
journalctl -u myapp -n 50
```

Not:

```text
randomly restart everything
```

---

## Log troubleshooting mindset

```text
Symptom
   ↓
Find relevant logs
   ↓
Find error
   ↓
Understand error
   ↓
Test likely cause
   ↓
Fix root cause
   ↓
Verify
```

---

# 13. Package Management

Ubuntu uses APT for package management.

A **package** contains software and associated metadata.

APT can obtain packages from configured repositories.

---

## `apt update`

```bash
sudo apt update
```

This refreshes the local package index.

Think:

```text
Configured repositories
       ↓
apt update
       ↓
Local machine learns what package versions are available
```

It does **not** mean all installed applications were upgraded.

---

## `apt upgrade`

```bash
sudo apt upgrade
```

This upgrades eligible installed packages based on available package information and APT's dependency decisions.

---

## Install

```bash
sudo apt install nginx
```

---

## Remove

```bash
sudo apt remove nginx
```

---

## Search

```bash
apt search nginx
```

---

## Installed packages

```bash
apt list --installed
```

Filter:

```bash
apt list --installed 2>/dev/null | grep nginx
```

---

## `which`

```bash
which curl
```

might return:

```text
/usr/bin/curl
```

This tells you which executable would be used for that command in the current command-search path.

During practice:

```bash
which curl
which git
which nginx
```

showed that `curl` and `git` were available while `nginx` was not found.

---

# 14. Environment Variables

Environment variables store configuration available to processes.

Examples:

```text
APP_ENV
DATABASE_HOST
PORT
AWS_REGION
```

---

## Why use them?

Imagine your application runs in:

```text
Development
Testing
Production
```

Hardcoding:

```text
DATABASE_HOST=production-db
```

inside source code makes environment changes awkward and potentially unsafe.

Instead:

```text
Development:
DATABASE_HOST=localhost

Testing:
DATABASE_HOST=test-db

Production:
DATABASE_HOST=prod-db
```

The application code can remain the same while configuration changes.

---

## Existing variables

```bash
echo $USER
```

```bash
echo $HOME
```

```bash
echo $PATH
```

---

# PATH

`PATH` contains directories the shell searches when you type a command.

Suppose:

```bash
which git
```

returns:

```text
/usr/bin/git
```

When you type:

```bash
git
```

the shell can locate the executable through its command search path rather than requiring:

```bash
/usr/bin/git
```

every time.

---

## Shell variable

```bash
DEVOPS_ENV=production
```

Check:

```bash
echo $DEVOPS_ENV
```

---

## Exported environment variable

```bash
export DEVOPS_ENV=production
```

This makes the variable available to child processes launched from that shell.

Check:

```bash
printenv DEVOPS_ENV
```

---

## Persistence

Variables defined interactively normally disappear when that shell session ends.

Common shell startup/configuration files include:

```text
~/.bashrc
~/.profile
```

Reload Bash configuration:

```bash
source ~/.bashrc
```

---

## Security warning

Environment variables can help avoid hardcoding credentials into source code.

But:

> Environment variables are not automatically secure secret storage.

For production secrets, dedicated secret-management mechanisms are often more appropriate.

Never commit credentials, API keys, private keys, or secret-filled `.env` files to a public repository.

---

# 15. SSH

SSH means:

```text
Secure Shell
```

It allows secure remote administration.

Typical default:

```text
Protocol: TCP
Port: 22
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

# SSH Key Authentication

SSH can use public-key cryptography.

You have:

```text
Private key
Public key
```

The private key must remain private.

Conceptually:

```text
Your machine                     Server
-----------                      ------
Private key                      Authorized public key
     │
     └──────── authentication ───────►
```

---

## Generate key

```bash
ssh-keygen
```

Common files might be:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```

Typically:

```text
id_ed25519      → private key
id_ed25519.pub  → public key
```

Never expose the private key.

---

## EC2 example

```bash
ssh -i my-key.pem ubuntu@SERVER_IP
```

Breakdown:

```text
ssh          SSH client
-i           identity file option
my-key.pem   private key
ubuntu       username
SERVER_IP    destination
```

---

# SSH Troubleshooting

If SSH fails:

```text
Correct hostname/IP?
       ↓
Network path exists?
       ↓
TCP port 22 reachable?
       ↓
Firewall/security group allows it?
       ↓
Routing correct?
       ↓
SSH service running?
       ↓
Correct username?
       ↓
Correct key?
```

---

## Timeout vs Permission Denied

These indicate very different failure stages.

### Connection timeout

Think first about:

```text
network path
routing
firewall
security group
port 22
service reachability
```

### Permission denied (publickey)

This usually means you reached an SSH server far enough for authentication to occur.

Think:

```text
username
private key
authorized public key
authentication configuration
```

---

# 16. Disk

Disk is persistent storage.

It holds things such as:

```text
Operating-system files
Application files
Logs
Databases
Container images
Backups
```

---

## `df`

```bash
df -h
```

Think:

> **How full are my filesystems?**

`-h` means human-readable sizes.

Example:

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       100G   95G   5G   95% /
```

---

## `du`

```bash
du -sh /var/log
```

Think:

> **How much space is this directory/file consuming?**

Useful:

```bash
du -sh ~/* 2>/dev/null
```

---

## `df` vs `du`

Remember:

```text
df = filesystem capacity/usage

du = file/directory space usage
```

Typical troubleshooting:

```text
df -h
  ↓
Which filesystem is full?
  ↓
du
  ↓
What is consuming the space?
```

---

# 17. Memory

RAM is temporary working memory used by running applications.

Check:

```bash
free -h
```

You may see:

```text
total
used
free
shared
buff/cache
available
```

---

## Free vs Available

Linux uses otherwise-unused memory for caching.

Therefore:

```text
free
```

alone can be misleading.

The:

```text
available
```

value is often more useful when judging how much memory can be made available to applications without swapping heavily.

---

## Memory analogy

```text
Disk = storage cupboard

RAM = working desk
```

The cupboard stores things long-term.

The desk holds what you are actively working with.

---

## Process memory

Use:

```bash
top
```

or:

```bash
ps aux
```

Look at:

```text
%MEM
```

---

# 18. CPU

The CPU executes instructions.

High CPU can make applications or servers slow, but:

> High CPU is a symptom. You still need to determine the cause.

---

## Investigate

```bash
top
```

or:

```bash
ps aux
```

Look for high:

```text
%CPU
```

Then ask:

```text
Which process?
What application owns it?
Is this expected?
What do its logs say?
Did traffic increase?
Is it stuck?
Is there a code/configuration issue?
```

---

## Correct troubleshooting approach

```text
Observe
   ↓
Identify high-CPU process
   ↓
Investigate process
   ↓
Check logs/behavior
   ↓
Determine root cause
   ↓
Take action
   ↓
Verify
```

Do not make:

```bash
kill -9
```

your automatic first response.

---

# PART II — NETWORKING

# 19. Networking Mental Model

Applications need networking to communicate.

At a practical DevOps level, understand how these pieces connect:

```text
Application
    ↓
Port
    ↓
TCP/UDP
    ↓
IP address/interface
    ↓
Routing
    ↓
Network
    ↓
Destination
```

DNS adds human-readable names:

```text
Hostname
   ↓
DNS
   ↓
IP
```

Firewalls determine whether particular traffic is allowed.

---

# 20. Network Interfaces

A network interface is a point through which a system communicates with a network.

Inspect:

```bash
ip addr
```

Short form:

```bash
ip a
```

During practice, interfaces included examples like:

```text
lo
eno1
wlo1
```

Typical interpretation:

```text
lo    → loopback
eno1  → Ethernet
wlo1  → Wi-Fi
```

An interface may be:

```text
UP
DOWN
NO-CARRIER
```

---

# 21. IP Addresses

An IP address identifies a network interface/destination so traffic can be routed.

Example private IPv4 address from practice:

```text
192.168.1.167
```

---

## Private vs Public

Private IPv4 ranges include:

```text
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

These are used within private networks and are not directly globally routable on the public Internet.

A machine on a home network might have:

```text
192.168.1.167
```

internally while the router/network uses a different public IP toward the Internet.

---

## IPv4 vs IPv6

IPv4 example:

```text
192.168.1.167
```

IPv6 example:

```text
2001:db8::1
```

IPv6 provides a vastly larger address space.

For this refresh, the important point is recognizing that modern systems can have both IPv4 and IPv6 addresses.

---

# 22. Localhost and Loopback

The IPv4 loopback address is:

```text
127.0.0.1
```

Common hostname:

```text
localhost
```

Meaning:

> This machine itself.

Example:

```bash
curl http://127.0.0.1:8080
```

tests an application through the local machine's loopback interface.

---

# 23. CIDR Basics

You saw:

```text
192.168.1.167/24
```

The `/24` is CIDR prefix notation.

For IPv4, `/24` means the first 24 bits identify the network prefix.

A common `/24` network might look like:

```text
192.168.1.0/24
```

At this stage, the key idea is:

```text
IP address = individual interface address

CIDR prefix = tells us how much of the address represents the network portion
```

We do not need advanced subnet calculations yet, but CIDR becomes very important in AWS VPCs, Kubernetes, routing, and firewall rules.

---

# 24. Ports and Sockets

An IP gets traffic to the appropriate network destination.

A port helps identify the application/service endpoint on that destination.

Analogy:

```text
IP address = building address
Port       = specific door/service
```

Example:

```text
192.168.1.50:8080
```

means:

```text
Host = 192.168.1.50
Port = 8080
```

---

## Common ports

| Port | Common Service |
|---:|---|
| 22 | SSH |
| 53 | DNS |
| 80 | HTTP |
| 443 | HTTPS |
| 5432 | PostgreSQL |
| 6379 | Redis |
| 8080 | Frequently used application/alternative HTTP port |

These are conventions/defaults; applications can often be configured to use different ports.

---

# Inspect sockets

```bash
ss -tuln
```

Breakdown:

```text
-t = TCP
-u = UDP
-l = listening
-n = numeric addresses/ports
```

To show associated processes where permitted:

```bash
sudo ss -tulpn
```

`p` adds process information.

---

# Listening Address Matters

Suppose:

```text
127.0.0.1:8080
```

This means the application is bound to the loopback interface.

Result:

```text
same machine → can connect

other machines → cannot directly connect to that listener
```

---

Suppose:

```text
0.0.0.0:8080
```

This means:

> Listen on all IPv4 interfaces.

But this does **not** automatically mean:

> Everyone on the Internet can access it.

Other layers still matter:

```text
routing
NAT
host firewall
cloud firewall/security groups
load balancer
network ACLs
```

---

# 25. TCP vs UDP

Both TCP and UDP operate at the transport layer.

---

## TCP

TCP is:

```text
Connection-oriented
Reliable
Ordered
```

It provides mechanisms for:

```text
acknowledgment
retransmission
ordered delivery
```

Common examples:

```text
SSH
HTTP/1.1
HTTP/2
HTTPS using HTTP/1.1 or HTTP/2
```

---

## UDP

UDP is:

```text
Connectionless
Lower protocol overhead
No TCP-style guarantee of delivery
No TCP-style guarantee of ordering
```

Applications using UDP can implement their own reliability behavior when needed.

Common examples include DNS queries and modern protocols such as QUIC.

---

## DNS and TCP/UDP

Do not memorize:

```text
DNS = UDP only
```

DNS commonly uses UDP for ordinary queries but can also use TCP.

---

## Quick comparison

| TCP | UDP |
|---|---|
| Connection-oriented | Connectionless |
| Reliable delivery mechanisms | No built-in delivery guarantee |
| Ordered byte stream | Datagram-oriented |
| More protocol overhead | Less protocol overhead |
| SSH, HTTP/1.1, HTTP/2 | Common DNS queries, QUIC |

---

# 26. DNS

DNS means:

```text
Domain Name System
```

Humans prefer:

```text
github.com
```

Computers need network addresses.

DNS helps translate names into information such as IP addresses.

Simplified:

```text
github.com
    ↓
DNS
    ↓
140.x.x.x
```

---

# DNS Resolver

Your computer usually sends DNS queries to a resolver.

During practice:

```bash
nslookup github.com
```

showed a local resolver such as:

```text
127.0.0.53
```

This is a loopback address commonly associated with the local system resolver setup on Ubuntu systems using `systemd-resolved`.

---

# DNS Port

Standard DNS service port:

```text
53
```

---

# Important DNS Records

## A

Maps a hostname to IPv4.

```text
example.com
    ↓ A
203.0.113.10
```

---

## AAAA

Maps hostname to IPv6.

---

## CNAME

Aliases one hostname to another hostname.

Example concept:

```text
www.example.com
       ↓ CNAME
app.example.net
```

---

# `nslookup`

```bash
nslookup github.com
```

Useful for a straightforward DNS lookup.

---

# `dig`

```bash
dig github.com
```

Provides more detailed DNS information.

Important output areas include:

```text
status
QUESTION SECTION
ANSWER SECTION
SERVER
```

---

## `NOERROR`

If:

```text
status: NOERROR
```

the DNS query completed successfully at the protocol level.

---

## `NXDOMAIN`

Generally means:

```text
The queried domain name does not exist in DNS.
```

---

# DNS Troubleshooting

Suppose:

```bash
nslookup example.com
```

fails.

Do not immediately say:

```text
Internet is down.
```

Separate the layers.

Test IP connectivity separately where appropriate:

```bash
ping -c 4 8.8.8.8
```

If direct IP connectivity works but hostname resolution fails, DNS becomes a stronger suspect.

Then investigate:

```bash
dig example.com
nslookup example.com
```

---

# 27. HTTP and HTTPS

HTTP means:

```text
Hypertext Transfer Protocol
```

It defines how clients and web servers exchange requests and responses.

---

## Common ports

```text
HTTP  → 80
HTTPS → 443
```

---

# HTTP Request

Conceptually:

```text
Client
   ↓
HTTP Request
   ↓
Server
```

A request contains information such as:

```text
method
path
headers
possibly a body
```

Common methods include:

```text
GET
POST
PUT
PATCH
DELETE
```

---

# HTTP Response

Server returns:

```text
status code
headers
possibly a response body
```

---

# Important status codes

## 2xx — Success

```text
200 OK
```

---

## 3xx — Redirection

```text
301 Moved Permanently
302 Found / temporary redirect behavior
```

---

## 4xx — Client-side request/auth/access issues

```text
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
```

---

## 5xx — Server-side/gateway issues

```text
500 Internal Server Error
502 Bad Gateway
503 Service Unavailable
```

---

# `curl`

`curl` is extremely useful for DevOps troubleshooting.

Request a URL:

```bash
curl https://example.com
```

Headers:

```bash
curl -I https://example.com
```

During practice:

```bash
curl -I https://github.com
```

returned a successful response such as:

```text
HTTP/2 200
```

This tells us much more about the web endpoint than simply testing whether the hostname resolves.

---

# DNS vs HTTP Testing

This is an important distinction.

```bash
nslookup github.com
```

asks:

> Can I resolve this hostname?

While:

```bash
curl -I https://github.com
```

asks, broadly:

> Can I communicate with the web endpoint and receive an HTTP response?

Therefore:

```text
DNS succeeds
+
curl fails
```

means you should not automatically blame DNS.

Investigate later layers:

```text
network connectivity
routing
port 443
firewall
TLS
web server
proxy/load balancer
application
```

---

# 28. TLS

HTTPS is HTTP protected by TLS.

TLS provides security properties including:

```text
Encryption
Integrity
Server authentication
```

Server authentication commonly uses digital certificates.

Simplified:

```text
Client
   ↓
TCP connection for HTTP/1.1 or HTTP/2
   ↓
TLS handshake
   ↓
Server presents certificate
   ↓
Client validates certificate
   ↓
Cryptographic parameters established
   ↓
Encrypted HTTP communication
```

Note that HTTP/3 uses QUIC over UDP rather than the traditional TCP model.

For most foundational DevOps interview explanations, understanding the HTTP/1.1/HTTP/2 + TCP + TLS path is still essential.

---

# 29. Routing and Default Gateway

Routing determines where network packets should go.

Inspect:

```bash
ip route
```

During practice, the output resembled:

```text
default via 192.168.1.1 dev wlo1
192.168.1.0/24 dev wlo1
```

---

## Directly connected route

```text
192.168.1.0/24 dev wlo1
```

means traffic for that network can be sent through the Wi-Fi interface according to that directly connected route.

---

## Default route

```text
default via 192.168.1.1
```

means:

> When no more specific route matches, send traffic toward this gateway.

Simplified:

```text
Laptop
  ↓
Default Gateway
  ↓
Other Networks
  ↓
Internet/Destination
```

---

# 30. Firewalls and Cloud Security Rules

A firewall controls allowed/blocked network traffic according to rules.

Rules can consider things such as:

```text
source
destination
protocol
port
direction
```

---

## UFW

Ubuntu commonly provides:

```text
ufw
```

Check:

```bash
sudo ufw status
```

During practice:

```text
Status: inactive
```

This means:

> UFW itself is not actively enforcing its rules.

It does NOT necessarily mean:

> There is no firewall or traffic filtering anywhere.

Cloud infrastructure may have additional controls.

---

# Cloud example

Suppose an EC2 application listens on:

```text
0.0.0.0:8080
```

Traffic may still need to pass:

```text
Client
   ↓
Internet/network
   ↓
AWS networking
   ↓
Security Group
   ↓
Operating-system firewall
   ↓
Network interface
   ↓
Port 8080
   ↓
Application
```

Therefore:

> Running ≠ reachable.

And:

> Listening ≠ reachable from every network.

---

# `0.0.0.0/0`

This CIDR represents:

```text
all IPv4 addresses
```

If an inbound SSH rule permits:

```text
TCP 22 from 0.0.0.0/0
```

SSH is potentially exposed to connection attempts from anywhere that can route to the server.

For administrative access, restrict the source to an appropriate trusted IP/range where practical.

---

# 31. What Happens When You Visit a Website?

This is one of the most useful DevOps interview questions.

Suppose:

```text
https://example.com
```

is entered into a browser.

A simplified sequence:

```text
1. Browser interprets URL
          ↓
2. DNS resolves example.com
          ↓
3. Client obtains destination IP
          ↓
4. Operating system checks routing
          ↓
5. Traffic travels toward destination
          ↓
6. For HTTP/1.1 or HTTP/2 HTTPS:
   TCP connection is established
          ↓
7. Usually destination port 443
          ↓
8. TLS handshake occurs
          ↓
9. Certificate is validated
          ↓
10. Secure connection established
          ↓
11. Browser sends HTTP request
          ↓
12. Server/load balancer/proxy/app processes request
          ↓
13. HTTP response returned
          ↓
14. Browser processes resources
          ↓
15. Page rendered
```

---

# Map Commands to the Layers

```text
IP/interface
→ ip a

DNS
→ dig
→ nslookup

Routing
→ ip route

Listening ports
→ ss

Reachability clue
→ ping

HTTP/HTTPS
→ curl

Service
→ systemctl

Service logs
→ journalctl
```

This is why understanding the layers makes troubleshooting easier.

---

# PART III — TROUBLESHOOTING

# 32. Troubleshooting Methodology

The most important Day 1 lesson is not a command.

It is a **method**.

Use:

```text
OBSERVE
   ↓
IDENTIFY THE SYMPTOM
   ↓
GATHER EVIDENCE
   ↓
FORM A HYPOTHESIS
   ↓
TEST IT
   ↓
IDENTIFY ROOT CAUSE
   ↓
FIX
   ↓
VERIFY
```

Avoid:

```text
Something broke
    ↓
Restart everything
    ↓
Change random settings
    ↓
Hope
```

A good DevOps engineer asks:

```text
What evidence do I have?
Which layer is failing?
What changed?
How can I prove my hypothesis?
How will I verify the fix?
```

---

# 33. Troubleshooting Disk Full

Problem:

```text
Server reports insufficient disk space.
```

## Step 1 — Filesystem usage

```bash
df -h
```

Find the affected filesystem.

---

## Step 2 — Find consumption

Use `du` on appropriate directories:

```bash
du -sh /var/*
```

or:

```bash
du -sh ~/*
```

---

## Step 3 — Investigate

Potential causes:

```text
large logs
container images/data
application output
database files
backups
temporary files
unexpected file growth
```

---

## Step 4 — Fix safely

Depending on the cause:

```text
rotate/archive logs
remove genuinely unnecessary data
correct runaway application
increase storage if justified
implement retention policies
```

Do not blindly delete files from production.

---

## Step 5 — Verify

```bash
df -h
```

---

# 34. Troubleshooting High CPU

Problem:

```text
Server is slow.
CPU appears high.
```

Start:

```bash
top
```

Identify process.

Alternative:

```bash
ps aux
```

Then:

```text
Which PID?
Which application?
Expected workload?
Logs?
Traffic spike?
Application loop?
Recent deployment?
```

Fix based on evidence.

Then verify again:

```bash
top
```

---

# 35. Troubleshooting Memory Problems

Start:

```bash
free -h
```

Look especially at:

```text
available
```

Then inspect processes:

```bash
top
```

or:

```bash
ps aux
```

Questions:

```text
Which process consumes memory?
Is usage growing?
Is it expected?
Did workload increase?
Could there be a memory leak?
Is the server appropriately sized?
```

Do not conclude there is a memory problem simply because the raw `free` value looks small.

---

# 36. Troubleshooting an Application That Is Not Running

Suppose:

```bash
systemctl status myapp
```

shows:

```text
Active: failed
```

Because systemd already tells us the service failed, investigate that evidence.

Next:

```bash
journalctl -u myapp -n 50
```

Potential causes:

```text
bad configuration
permission denied
missing dependency
port conflict
database unavailable
missing file
resource exhaustion
application error
```

Fix the identified cause.

Then:

```bash
sudo systemctl restart myapp
```

Verify:

```bash
systemctl status myapp
```

And test the actual application.

---

# 37. Troubleshooting a Service That Keeps Crashing

Suppose:

```text
start
↓
run briefly
↓
crash
↓
restart
↓
crash
```

Do not keep restarting indefinitely.

Use:

```bash
systemctl status myapp
```

then:

```bash
journalctl -u myapp -n 50
```

Investigate:

```text
configuration
permissions
dependencies
ports
resources
application errors
```

The crash is the symptom.

The logs may reveal the root cause.

---

# 38. Troubleshooting Port 8080 Not Accessible

Scenario:

```text
Application service = active
Users cannot access :8080
```

First:

```bash
sudo ss -tulpn | grep :8080
```

---

## Case 1 — No output

Possibility:

```text
Nothing is listening on 8080.
```

Investigate application configuration/service.

---

## Case 2

```text
127.0.0.1:8080
```

Application listens only on loopback.

Remote clients cannot directly connect to that listener.

---

## Case 3

```text
0.0.0.0:8080
```

Application listens on all IPv4 interfaces.

Now test locally:

```bash
curl http://localhost:8080
```

If local succeeds but remote fails, investigate:

```text
host firewall
cloud security group/firewall
routing
NAT
load balancer
network ACL
client path
```

---

## Layer-by-layer reasoning

```text
Service running?
       ↓
Port listening?
       ↓
Correct binding?
       ↓
Local curl works?
       ↓
Firewall allows?
       ↓
Cloud/network rules allow?
       ↓
Route exists?
       ↓
Remote test
```

---

# 39. Troubleshooting DNS Failure

Suppose:

```bash
curl https://myapp.example.com
```

fails because the hostname cannot resolve.

Test:

```bash
dig myapp.example.com
```

or:

```bash
nslookup myapp.example.com
```

If name resolution fails, investigate DNS.

But also separate general connectivity from DNS when necessary.

Example:

```bash
ping -c 4 8.8.8.8
```

If IP connectivity works while hostname lookup fails:

```text
network path may be working
DNS becomes a stronger suspect
```

Investigate:

```text
resolver configuration
DNS records
record names
record values
DNS server availability
```

---

# 40. Troubleshooting an Unreachable Server

Suppose:

```bash
ssh ubuntu@SERVER_IP
```

fails.

Use layers.

```text
Correct IP?
    ↓
Correct route/network path?
    ↓
Required port reachable?
    ↓
Security group/firewall?
    ↓
SSH service?
    ↓
Username?
    ↓
Authentication key?
```

---

## Ping caveat

You can try:

```bash
ping SERVER_IP
```

But:

> Failed ping does not prove the server is down.

ICMP may be blocked.

---

## SSH timeout

If:

```text
Connection timed out
```

think:

```text
network
routing
firewall
security group
TCP 22
service reachability
```

---

## Public key error

If:

```text
Permission denied (publickey)
```

you reached an SSH server and authentication is failing.

Think:

```text
username
private key
public key authorization
SSH authentication configuration
```

That distinction is extremely useful in interviews.

---

# PART IV — INTERVIEW & REVISION

# 41. Interview Questions

## 1. What is `/` compared with `/root`?

**Answer:**

`/` is the root of the entire Linux filesystem hierarchy. `/root` is the home directory of the root user.

---

## 2. What is `/etc`?

`/etc` commonly contains system-wide and application configuration files.

---

## 3. What is `/var/log`?

A common location for system and application log files.

---

## 4. What is the difference between `>` and `>>`?

```text
>  overwrites/creates output file

>> appends to output file
```

---

## 5. Difference between `cat` and `tail -f`?

`cat` prints file contents.

`tail -f` follows the end of a file and displays new lines as they are added, making it useful for live log monitoring.

---

## 6. Explain `chmod 644`.

```text
6 = rw- = owner can read/write
4 = r-- = group can read
4 = r-- = others can read
```

Therefore:

```text
rw-r--r--
```

---

## 7. Explain `chmod 755`.

```text
7 = rwx
5 = r-x
5 = r-x
```

Therefore:

```text
rwxr-xr-x
```

---

## 8. Convert `rwxr-x---` to numeric notation.

```text
rwx = 4+2+1 = 7
r-x = 4+1   = 5
--- = 0
```

Answer:

```text
750
```

---

## 9. What do owner, group and others mean?

They are the three permission classes used to determine access to a Linux file or directory.

---

## 10. What is a process?

A process is a running instance of a program.

---

## 11. What is the difference between process and service?

A process is a running program.

A service commonly represents background functionality managed by a service manager such as systemd and may consist of one or more processes.

---

## 12. `kill` vs `kill -9`?

`kill PID` normally sends SIGTERM, requesting graceful termination.

`kill -9 PID` sends SIGKILL and forcefully terminates the process without allowing normal cleanup.

I would generally try graceful termination first and investigate before using SIGKILL.

---

## 13. Start vs enable?

```text
start  → run service now

enable → configure service for automatic startup according to systemd unit installation/boot configuration
```

---

## 14. How do you investigate a failed service?

```bash
systemctl status SERVICE
journalctl -u SERVICE -n 50
```

I would inspect the actual error, identify the root cause, fix it, restart when appropriate, and verify both the service and application.

---

## 15. `apt update` vs `apt upgrade`?

`apt update` refreshes local package metadata.

`apt upgrade` upgrades eligible installed packages based on the available package information.

---

## 16. Why environment variables?

They separate configuration from source code, allowing the same application to run in different environments with different configuration.

They also reduce the need to hardcode configuration or credentials, although they are not automatically a secure secrets-management solution.

---

## 17. `df` vs `du`?

```text
df → filesystem usage/capacity

du → file/directory disk usage
```

---

## 18. How would you investigate high CPU?

I would use `top` or `ps aux` to identify the process consuming CPU, determine which application owns it, inspect its logs and behavior, identify the root cause, apply an appropriate fix, and verify CPU usage afterward.

---

## 19. What is localhost?

`localhost` refers to the local machine, normally resolving to loopback addresses such as IPv4 `127.0.0.1`.

---

## 20. IP vs port?

An IP address identifies the network destination/interface. A port identifies a service/application endpoint on that host.

---

## 21. `127.0.0.1:8080` vs `0.0.0.0:8080`?

`127.0.0.1:8080` accepts IPv4 connections only through the local loopback interface.

`0.0.0.0:8080` means the application listens on port 8080 across all IPv4 interfaces.

The latter still does not guarantee external reachability because routing and security rules also matter.

---

## 22. TCP vs UDP?

TCP is connection-oriented and provides reliable, ordered delivery mechanisms.

UDP is connectionless and does not provide TCP's built-in delivery and ordering guarantees, with lower protocol overhead.

---

## 23. What does DNS do?

DNS resolves domain names and provides records such as IP addresses, allowing clients to locate services using human-readable names.

---

## 24. A vs AAAA vs CNAME?

```text
A     → hostname to IPv4

AAAA  → hostname to IPv6

CNAME → alias hostname to another hostname
```

---

## 25. `dig` vs `curl`?

`dig` investigates DNS.

`curl` sends requests to URLs/protocol endpoints and is commonly used to test HTTP/HTTPS services.

---

## 26. What happens when you access a website?

A strong concise answer:

> When I enter a URL, the hostname is resolved through DNS to obtain a destination IP. The operating system determines the route toward that destination. For a typical HTTPS connection using HTTP/1.1 or HTTP/2, the client establishes a TCP connection, normally to port 443. A TLS handshake establishes an encrypted connection and authenticates the server through its certificate. The browser then sends an HTTP request. The server processes the request and returns an HTTP response containing a status code, headers, and potentially content, which the browser processes and renders.

---

## 27. DNS works but HTTPS does not. What next?

If DNS resolution succeeds, I would investigate later layers such as:

```text
routing/connectivity
TCP 443
firewall/security rules
TLS/certificate
load balancer/proxy
web server
application
```

---

## 28. App works locally but not remotely. What would you check?

I would check:

```text
listening port
binding address
host firewall
cloud security rules
routing
NAT/load balancer if relevant
```

I would use `ss` to inspect the listener and `curl` locally to separate application problems from network-path problems.

---

# 42. Revision Quiz

Try answering these **without looking above**.

### Linux

1. What is the difference between `/` and `/root`?
2. What type of files commonly live under `/etc`?
3. Why is `/var/log` important?
4. What does `pwd` do?
5. What is an absolute path?
6. What is a relative path?
7. What is the difference between `cp` and `mv`?
8. What is the difference between `>` and `>>`?
9. What does a pipe `|` do?
10. What does `grep` do?

### Permissions

11. What do `r`, `w`, and `x` mean?
12. What are owner, group and others?
13. What numeric value is `r`?
14. What numeric value is `w`?
15. What numeric value is `x`?
16. Convert `rwx` to numeric.
17. Convert `r-x` to numeric.
18. Convert `rw-` to numeric.
19. Explain `644`.
20. Explain `755`.
21. Convert `rwxr-x---` to numeric.
22. What does `chmod u+x file` do?
23. What does `chmod g-w file` do?
24. Why does execute permission have a different practical meaning on a directory?

### Users/Processes/Services

25. What does `whoami` tell you?
26. What does `id` tell you?
27. Why are groups useful?
28. What is a PID?
29. What does `ps aux` show?
30. Why might Chrome have many processes?
31. Difference between SIGTERM and SIGKILL?
32. Why should `kill -9` not automatically be your first action?
33. Difference between process, daemon and service?
34. Difference between `systemctl stop` and `systemctl disable`?
35. What does `journalctl -u docker` show?

### Packages/Environment/Resources

36. Difference between `apt update` and `apt upgrade`?
37. What does `which git` tell you?
38. Why use environment variables?
39. What does `$PATH` do?
40. Why are environment variables not automatically secure secret storage?
41. Difference between `df` and `du`?
42. Why is `available` memory useful?
43. How would you investigate high CPU?

### Networking

44. What is a network interface?
45. What is localhost?
46. What is `127.0.0.1`?
47. What is a private IP?
48. What does `/24` represent?
49. What is the difference between IP and port?
50. What does `ss -tuln` show?
51. Difference between `127.0.0.1:8080` and `0.0.0.0:8080`?
52. Difference between TCP and UDP?
53. Can DNS use both UDP and TCP?
54. What is an A record?
55. What is an AAAA record?
56. What is a CNAME?
57. What does `dig` help troubleshoot?
58. What does `curl` help troubleshoot?
59. What is the default HTTPS port?
60. What does TLS provide?
61. What is a default gateway?
62. What does `ip route` show?
63. Why doesn't a listening application automatically mean it is remotely accessible?
64. Why doesn't failed `ping` automatically mean a server is down?
65. What is the difference between SSH timeout and `Permission denied (publickey)`?

### Troubleshooting

66. Server is 98% full. What is your first command?
67. Service says `failed`. What evidence would you inspect?
68. App is running but port 8080 is inaccessible. What command checks the listener?
69. App works on localhost but not remotely. Which layers would you investigate?
70. CPU is at 100%. Why shouldn't your first action necessarily be `kill -9`?
71. DNS resolution fails but direct IP connectivity works. What subsystem becomes a strong suspect?
72. What are the steps in our troubleshooting methodology?

---

# 43. Command Reference

| Command | Purpose | Example |
|---|---|---|
| `pwd` | Current directory | `pwd` |
| `ls` | List directory | `ls -la` |
| `cd` | Change directory | `cd /var/log` |
| `mkdir` | Create directory | `mkdir -p app/logs` |
| `touch` | Create empty file/update timestamp | `touch app.log` |
| `cp` | Copy | `cp a.txt b.txt` |
| `mv` | Move/rename | `mv old new` |
| `rm` | Remove | `rm file.txt` |
| `cat` | Print file | `cat app.log` |
| `less` | Interactive file viewing | `less app.log` |
| `head` | Beginning of file | `head -5 file` |
| `tail` | End of file | `tail -f app.log` |
| `grep` | Search matching text | `grep ERROR app.log` |
| `find` | Find files/directories | `find . -name "*.log"` |
| `chmod` | Change permissions | `chmod 755 deploy.sh` |
| `chown` | Change ownership | `chown user:group file` |
| `whoami` | Current user | `whoami` |
| `id` | UID/GID/groups | `id` |
| `groups` | User groups | `groups` |
| `ps` | Processes | `ps aux` |
| `top` | Live processes/resources | `top` |
| `kill` | Send signal to process | `kill PID` |
| `systemctl` | Manage systemd units | `systemctl status docker` |
| `journalctl` | Read systemd journal | `journalctl -u docker` |
| `apt` | Package management | `sudo apt update` |
| `which` | Locate command in search path | `which git` |
| `printenv` | Display environment variables | `printenv PATH` |
| `df` | Filesystem usage | `df -h` |
| `du` | File/directory usage | `du -sh /var/log` |
| `free` | Memory usage | `free -h` |
| `ip` | Network configuration | `ip a` |
| `ip route` | Routing table | `ip route` |
| `ss` | Socket information | `ss -tuln` |
| `ping` | ICMP reachability/latency clue | `ping -c 4 8.8.8.8` |
| `dig` | DNS query/troubleshooting | `dig github.com` |
| `nslookup` | DNS lookup | `nslookup github.com` |
| `curl` | Test URLs/endpoints | `curl -I https://github.com` |
| `ssh` | Remote shell | `ssh user@server` |

---

# 44. Day 1 Mental Model

If you remember nothing else, remember how the concepts fit together.

## Linux

```text
FILESYSTEM
Where does the resource live?
        ↓
OWNERSHIP & PERMISSIONS
Who can access it?
        ↓
PROCESS
What program is running?
        ↓
SERVICE
How is the background application managed?
        ↓
LOGS
What happened?
        ↓
CPU / MEMORY / DISK
Does it have enough resources?
```

---

## Networking

```text
HOSTNAME
   ↓
DNS
   ↓
IP ADDRESS
   ↓
ROUTING
   ↓
DESTINATION HOST
   ↓
PORT
   ↓
TCP / UDP
   ↓
APPLICATION
```

Security controls can exist along the path:

```text
Client
  ↓
Network
  ↓
Cloud Firewall / Security Group
  ↓
Host Firewall
  ↓
Listening Socket
  ↓
Application
```

---

# 🔥 The Day 1 Troubleshooting Rule

Never begin with:

```text
"What command can I randomly try?"
```

Begin with:

```text
"What exactly is failing?"
```

Then:

```text
Observe
   ↓
Identify
   ↓
Gather evidence
   ↓
Form hypothesis
   ↓
Test
   ↓
Find root cause
   ↓
Fix
   ↓
Verify
```

---

# ✅ Day 1 Completion Checklist

## Linux

- [x] Linux fundamentals
- [x] Filesystem hierarchy
- [x] Absolute and relative paths
- [x] Files and directories
- [x] Pipes and redirection
- [x] Symbolic permissions
- [x] Numeric/octal permissions
- [x] Users and groups
- [x] Ownership
- [x] Processes
- [x] Signals
- [x] Services
- [x] systemd
- [x] Logs
- [x] Package management
- [x] Environment variables
- [x] SSH
- [x] Disk
- [x] Memory
- [x] CPU

## Networking

- [x] Interfaces
- [x] IPv4/IPv6 basics
- [x] Private IP addresses
- [x] Localhost
- [x] CIDR basics
- [x] Ports
- [x] Sockets
- [x] TCP
- [x] UDP
- [x] DNS
- [x] HTTP
- [x] HTTPS
- [x] TLS
- [x] Routing
- [x] Default gateway
- [x] Firewalls
- [x] Cloud security rules

## Troubleshooting

- [x] Disk full
- [x] High CPU
- [x] Memory investigation
- [x] Application not running
- [x] Service keeps crashing
- [x] Port inaccessible
- [x] Localhost-only binding
- [x] DNS failure
- [x] Server unreachable
- [x] SSH timeout
- [x] SSH authentication failure

---

# 🎯 Day 1 Complete

At this point, I should be able to:

1. Explain Linux permissions rather than just memorize `755`.
2. Investigate users, groups, processes and services.
3. Read logs and use them as troubleshooting evidence.
4. Distinguish CPU, RAM and disk problems.
5. Explain IP addresses, ports, TCP/UDP and DNS.
6. Explain how HTTP, HTTPS and TLS fit together.
7. Understand localhost and application binding.
8. Read basic Linux routing information.
9. Understand the role of firewalls and cloud security rules.
10. Troubleshoot infrastructure problems layer by layer.
11. Explain what happens when a browser accesses a website.
12. Troubleshoot SSH connectivity and authentication separately.

> **The goal is not to memorize every Linux command. The goal is to understand the system well enough to know what evidence to collect when something goes wrong.**

---

## ➡️ Next

**Day 2 — Git, GitHub & CI/CD**