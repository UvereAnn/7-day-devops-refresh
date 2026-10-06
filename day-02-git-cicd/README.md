# Day 2 — Git, GitHub & CI/CD

## 7-Day DevOps Refresh

Day 2 focused on building a practical understanding of **Git, GitHub, Continuous Integration, Continuous Delivery/Deployment, GitHub Actions, and Jenkins**.

The goal was not simply to memorize commands or pipeline syntax. The exercises were designed to understand how source code moves from a developer's local machine through version control, code review, automated testing, security checks, build validation, and deployment workflows.

A separate hands-on repository, `devops-cicd-lab`, was used for the practical exercises so that this documentation repository remained focused on learning notes.

---

# Table of Contents

1. [Learning Objectives](#learning-objectives)
2. [Git Mental Model](#git-mental-model)
3. [Essential Git Commands](#essential-git-commands)
4. [Git Branching](#git-branching)
5. [Merge Conflicts](#merge-conflicts)
6. [Git Remotes and GitHub](#git-remotes-and-github)
7. [Pull Requests](#pull-requests)
8. [Fetch vs Pull](#fetch-vs-pull)
9. [Undoing Changes](#undoing-changes)
10. [The CI/CD Mental Model](#the-cicd-mental-model)
11. [CI vs Continuous Delivery vs Continuous Deployment](#ci-vs-continuous-delivery-vs-continuous-deployment)
12. [Node.js CI/CD Lab Application](#nodejs-cicd-lab-application)
13. [GitHub Actions](#github-actions)
14. [GitHub Actions Workflow](#github-actions-workflow)
15. [Jobs, Steps and Runners](#jobs-steps-and-runners)
16. [Job Dependencies with `needs`](#job-dependencies-with-needs)
17. [Environment Variables and Secrets](#environment-variables-and-secrets)
18. [Artifacts vs Cache](#artifacts-vs-cache)
19. [CI/CD Security Gates](#cicd-security-gates)
20. [Deployment Conditions](#deployment-conditions)
21. [GitHub Actions Troubleshooting](#github-actions-troubleshooting)
22. [Jenkins Architecture](#jenkins-architecture)
23. [Jenkins on AWS EC2](#jenkins-on-aws-ec2)
24. [Jenkins Pipeline as Code](#jenkins-pipeline-as-code)
25. [Jenkins Parameters](#jenkins-parameters)
26. [Jenkins Artifacts](#jenkins-artifacts)
27. [Poll SCM](#poll-scm)
28. [GitHub Webhooks](#github-webhooks)
29. [Webhook vs Poll SCM](#webhook-vs-poll-scm)
30. [Jenkins Executor Troubleshooting](#jenkins-executor-troubleshooting)
31. [GitHub Actions vs Jenkins](#github-actions-vs-jenkins)
32. [CI/CD Troubleshooting Method](#cicd-troubleshooting-method)
33. [Common Interview Questions and Answers](#common-interview-questions-and-answers)
34. [Day 2 Final Review Questions](#day-2-final-review-questions)
35. [Key Takeaways](#key-takeaways)

---

# Learning Objectives

By the end of Day 2, I wanted to be able to:

- Understand the Git workflow.
- Create and manage branches.
- Resolve merge conflicts.
- Work with local and remote repositories.
- Understand GitHub Pull Requests.
- Explain CI/CD clearly.
- Build a CI pipeline using GitHub Actions.
- Understand jobs, steps, runners, dependencies, secrets, environments, artifacts, and caching.
- Implement test and security gates.
- Understand Jenkins architecture.
- Create a Jenkins Pipeline using a `Jenkinsfile`.
- Trigger Jenkins using Poll SCM and GitHub webhooks.
- Use Jenkins parameters and archived artifacts.
- Troubleshoot CI/CD pipeline failures systematically.
- Compare GitHub Actions and Jenkins.

---

# Git Mental Model

Git can be understood using four main areas:

```text
Working Directory
       |
       | git add
       v
Staging Area
       |
       | git commit
       v
Local Repository
       |
       | git push
       v
Remote Repository
```

## Working Directory

This is where files are actively edited.

Example:

```bash
vim src/app.js
```

The modification initially exists only in the working directory.

## Staging Area

The staging area contains changes selected for the next commit.

```bash
git add src/app.js
```

The file is now staged.

## Local Repository

A commit stores a snapshot in the local Git repository.

```bash
git commit -m "feat: update application"
```

## Remote Repository

The remote repository is normally hosted on a platform such as GitHub.

```bash
git push
```

This transfers local commits to the remote repository.

A useful mental model is:

```text
edit
 ↓
git add
 ↓
git commit
 ↓
git push
```

---

# Essential Git Commands

## Repository Status

```bash
git status
```

Shows:

- current branch
- modified files
- staged files
- untracked files

## Stage a File

```bash
git add filename
```

Stage everything:

```bash
git add .
```

## Commit Changes

```bash
git commit -m "commit message"
```

## View Commit History

```bash
git log
```

Compact form:

```bash
git log --oneline
```

Visual branch history:

```bash
git log --oneline --graph --decorate --all
```

## View Differences

Unstaged changes:

```bash
git diff
```

Staged changes:

```bash
git diff --staged
```

## Inspect a Commit

```bash
git show <commit-hash>
```

---

# Git Branching

Branches allow developers to work independently without immediately changing the main codebase.

Create and switch to a branch:

```bash
git switch -c feature/new-feature
```

This combines:

```text
create branch
+
switch to branch
```

List branches:

```bash
git branch
```

The current branch is marked with `*`.

Example:

```text
* feature/new-feature
  main
```

Switch branches:

```bash
git switch main
```

A typical workflow is:

```text
main
 |
 +---- feature/login
 |
 +---- feature/payment
 |
 +---- fix/security-bug
```

After work is reviewed, the feature branch can be merged into `main`.

---

# Merge Conflicts

A merge conflict occurs when Git cannot automatically determine how competing changes should be combined.

For example:

Developer A changes:

```text
Welcome to DevOps Lab
```

to:

```text
Welcome to the CI/CD Lab
```

while Developer B changes the same line to:

```text
Welcome to the Git Lab
```

Git may produce conflict markers:

```text
<<<<<<< HEAD
Welcome to the CI/CD Lab
=======
Welcome to the Git Lab
>>>>>>> feature-branch
```

The developer must decide what the final content should be.

After editing the file:

```bash
git add <file>
git commit
```

Important lesson:

> Editing the file fixes the content, but `git add` tells Git that the conflict has been resolved.

---

# Git Remotes and GitHub

A remote is a reference to another Git repository.

View remotes:

```bash
git remote -v
```

Add a remote:

```bash
git remote add origin <repository-url>
```

`origin` is simply the conventional name for the primary remote.

It does **not** mean GitHub.

The remote could be hosted on:

- GitHub
- GitLab
- Bitbucket
- another Git server

Push a branch and configure upstream tracking:

```bash
git push -u origin feature/example
```

After upstream tracking is configured:

```bash
git push
```

is normally sufficient.

---

# Pull Requests

A Pull Request proposes merging changes from one branch into another.

Example:

```text
feature/login
      |
      | Pull Request
      v
     main
```

A PR provides an opportunity for:

- code review
- automated CI checks
- discussion
- security checks
- approval
- controlled merging

New commits pushed to the same source branch automatically become part of the existing Pull Request.

A new PR is not required for every new commit.

---

# Fetch vs Pull

## `git fetch`

```bash
git fetch
```

Downloads information and commits from the remote but does not automatically integrate them into the current branch.

Conceptually:

```text
Remote
  |
  | download information
  v
Remote-tracking branches
```

## `git pull`

```bash
git pull
```

Retrieves remote changes and integrates them into the current branch.

A useful simplified model is:

```text
git pull ≈ git fetch + integration
```

After a PR is merged remotely, a common workflow is:

```bash
git switch main
git pull
```

---

# Undoing Changes

## Restore an Unstaged File

```bash
git restore filename
```

## Unstage a File

```bash
git restore --staged filename
```

## Revert

```bash
git revert <commit>
```

Creates a new commit that reverses an earlier commit.

This is useful when history has already been shared.

## Reset

`git reset` moves Git references and can rewrite local history depending on the selected mode.

Because reset can alter history, it should be used carefully, especially with shared branches.

---

# The CI/CD Mental Model

Without CI/CD:

```text
Developer
   |
Write code
   |
Manually test
   |
Manually build
   |
Manually deploy
```

With CI/CD:

```text
Developer
   |
Git Push / Pull Request
   |
   v
CI Pipeline
   |
   +--> Install dependencies
   |
   +--> Test
   |
   +--> Security checks
   |
   +--> Build / Validate
   |
   v
Deployment process
```

The pipeline creates a repeatable and automated path for software changes.

---

# CI vs Continuous Delivery vs Continuous Deployment

## Continuous Integration

Developers frequently integrate changes into a shared repository.

Automated checks validate those changes.

Typical CI activities include:

```text
Checkout
Install
Test
Security Scan
Build
Validate
```

## Continuous Delivery

The application is automatically tested and prepared for release, but production deployment requires a deliberate decision or approval.

```text
Code
 ↓
Test
 ↓
Build
 ↓
Release ready
 ↓
Manual approval
 ↓
Production
```

## Continuous Deployment

Changes that pass all required checks are automatically deployed.

```text
Code
 ↓
Test
 ↓
Security
 ↓
Build
 ↓
Deploy automatically
```

The important distinction is:

```text
Continuous Delivery   → deployment is ready but may require approval
Continuous Deployment → deployment happens automatically
```

---

# Node.js CI/CD Lab Application

A separate repository called:

```text
devops-cicd-lab
```

was used for the hands-on exercises.

The application included:

```text
devops-cicd-lab/
├── src/
│   ├── app.js
│   └── server.js
├── tests/
│   └── app.test.js
├── .github/
│   └── workflows/
│       └── ci.yml
├── Jenkinsfile
├── package.json
├── package-lock.json
├── .gitignore
└── README.md
```

The Node.js/Express application included:

```text
/
```

and:

```text
/health
```

endpoints.

Tests were implemented using Jest and Supertest.

Run tests locally:

```bash
npm test
```

Run tests with coverage:

```bash
npm test -- --coverage
```

---

# GitHub Actions

GitHub Actions was used to automate CI.

Workflow files are stored in:

```text
.github/workflows/
```

For example:

```text
.github/workflows/ci.yml
```

The basic hierarchy is:

```text
Workflow
   |
   +--- Job
   |     |
   |     +--- Step
   |     +--- Step
   |
   +--- Job
         |
         +--- Step
```

---

# GitHub Actions Workflow

The lab workflow implemented:

- push trigger
- Pull Request trigger
- Node.js setup
- dependency installation
- automated tests
- test coverage
- coverage artifact upload
- dependency security audit
- application validation
- secret handling
- job dependencies
- staging deployment simulation

Example structure:

```yaml
name: Node.js CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

env:
  NODE_ENV: test
```

This means the workflow runs when:

- code is pushed to `main`
- a Pull Request targets `main`

---

# Jobs, Steps and Runners

## Workflow

The entire automation definition.

## Job

A group of steps executed together.

Example:

```yaml
jobs:
  test:
```

## Step

An individual action or command inside a job.

Example:

```yaml
- name: Run tests
  run: npm test
```

## Runner

The machine/environment that executes a job.

Example:

```yaml
runs-on: ubuntu-latest
```

A useful mental model:

```text
Workflow
   |
   +--- Job
         |
         +--- Runner
               |
               +--- Step
               +--- Step
```

---

# `uses` vs `run`

## `uses`

Runs an existing reusable GitHub Action.

Example:

```yaml
- uses: actions/checkout@v4
```

## `run`

Executes a shell command.

Example:

```yaml
- run: npm test
```

Simple distinction:

```text
uses → reusable action
run  → shell command
```

---

# Job Dependencies with `needs`

Jobs can depend on other jobs.

Example:

```yaml
build:
  needs:
    - test
    - security
```

This creates:

```text
        test --------\
                      \
                       ---> build
                      /
security ------------/
```

`build` waits until both required jobs complete successfully.

If `security` fails:

```text
test       ✅
security   ❌
build      skipped
deploy     skipped
```

This is an example of a **pipeline gate**.

Important:

> `needs` controls execution dependencies. It does not automatically transfer files between jobs.

---

# Environment Variables and Secrets

## Environment Variables

A workflow-level variable can be defined with:

```yaml
env:
  NODE_ENV: test
```

Environment variables can exist at different scopes:

```text
Workflow
Job
Step
```

Use the smallest appropriate scope.

## Secrets

Sensitive values should not be hardcoded into repositories.

Examples:

- API tokens
- cloud credentials
- passwords
- deployment keys

GitHub Actions secrets are referenced using syntax such as:

```yaml
${{ secrets.LAB_SECRET }}
```

The lab verified that a secret existed without printing its value:

```bash
if [ -z "$LAB_SECRET" ]; then
  echo "LAB_SECRET is not configured"
  exit 1
fi

echo "LAB_SECRET is configured"
```

Secrets should never be committed directly into:

```text
source code
workflow files
Jenkinsfile
README files
```

---

# Artifacts vs Cache

Artifacts and caches solve different problems.

## Cache

A cache is primarily used to speed up future workflow runs.

Example:

```text
npm dependencies
```

Conceptually:

```text
Pipeline Run 1
   |
save reusable data
   |
Pipeline Run 2
   |
reuse data
```

## Artifact

An artifact preserves output produced by a pipeline.

Examples:

```text
coverage reports
build packages
compiled binaries
test reports
```

Conceptually:

```text
Pipeline
   |
generate output
   |
archive/upload
   |
preserved result
```

Simple distinction:

```text
Cache    → optimize future execution
Artifact → preserve pipeline output
```

---

# CI/CD Security Gates

The lab used:

```bash
npm audit --audit-level=high
```

as a dependency security check.

A security gate means later pipeline stages should not continue if required security checks fail.

Example:

```text
Tests ---------\
                \
                 ---> Build ---> Deploy
                /
Security ------/
```

This prevents known unacceptable conditions from silently progressing through the pipeline.

A security gate is a **pipeline policy or control**.

`npm audit` is one tool that can be used to implement such a gate.

---

# Deployment Conditions

The staging deployment was restricted using:

```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

This prevents deployment from running directly during a Pull Request workflow.

The behavior becomes:

```text
Pull Request
     |
     +--> Test
     +--> Security
     +--> Build
     |
     X Deploy
```

After the PR is merged:

```text
Push to main
     |
     +--> Test
     +--> Security
     +--> Build
     |
     +--> Deploy
```

This is important because CI success and deployment permission are separate decisions.

---

# GitHub Actions Troubleshooting

Several deliberate and real pipeline problems were investigated during the lab.

## 1. Incorrect Job Dependency

An incorrect job name in `needs` caused a workflow configuration failure.

Lesson:

> Dependency names must exactly match existing job IDs.

## 2. Shell Syntax Error

A malformed Bash secret check caused the command to exit with an error.

Lesson:

> A workflow can be valid YAML while a command inside it still fails at runtime.

This distinguishes:

```text
Configuration/parsing error
```

from:

```text
Runtime error
```

## 3. Incorrect Git Reference

The deployment condition contained an incorrect reference similar to:

```text
refs/head/main
```

instead of:

```text
refs/heads/main
```

The workflow itself remained valid, but the condition evaluated to false.

The deployment job was therefore skipped.

Important troubleshooting lesson:

> A skipped job does not necessarily mean the pipeline crashed. A condition may have evaluated to false.

## 4. YAML Indentation Error

Incorrect indentation caused workflow parsing errors.

YAML structure matters because indentation defines relationships between keys and sequences.

## 5. Hosted Runner Delay

During one Pull Request, GitHub Actions jobs remained at:

```text
Waiting for a hosted runner to come online
```

The application had not started running yet.

Therefore debugging:

```bash
npm test
```

would have been premature.

The correct reasoning was:

```text
Job has not obtained runner
        ↓
Application commands have not executed
        ↓
Investigate CI infrastructure/queue/service availability first
```

This reinforced an important troubleshooting principle:

> Identify which layer has failed before debugging the application.

---

# Jenkins Architecture

Jenkins introduced another CI/CD architecture.

The simplified model is:

```text
Developer
   |
   v
Git Repository
   |
   v
Jenkins Controller
   |
   | schedules work
   v
Jenkins Agent
   |
   | executor
   v
Pipeline Commands
```

## Controller

The Jenkins controller manages:

- pipeline configuration
- job scheduling
- credentials
- plugins
- nodes
- build coordination

Think of it as the coordinator.

## Agent

An agent provides an environment where Jenkins can execute pipeline work.

## Executor

An executor represents a slot capable of running work on a Jenkins node.

A node can have multiple executors.

Example:

```text
Agent
 ├── Executor 1
 └── Executor 2
```

## Jenkinsfile

The `Jenkinsfile` stores pipeline configuration as code.

This is called:

```text
Pipeline as Code
```

---

# Jenkins on AWS EC2

A temporary Ubuntu AWS EC2 instance was created specifically for the Jenkins practical.

The environment included:

- Ubuntu
- Java
- Jenkins
- Git
- Node.js
- npm

Jenkins was accessed through port:

```text
8080
```

The lab intentionally used a temporary cloud VM instead of installing Jenkins permanently on the local laptop.

After the exercise, the temporary EC2 environment was terminated to avoid leaving unnecessary cloud resources running.

---

# Jenkins Pipeline as Code

The pipeline was stored in the Git repository using a `Jenkinsfile`.

A simplified version:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test -- --coverage'
            }
        }

        stage('Archive Coverage') {
            steps {
                archiveArtifacts artifacts: 'coverage/**', fingerprint: true
            }
        }

        stage('Security Check') {
            steps {
                sh 'npm audit --audit-level=high'
            }
        }

        stage('Validate Application') {
            steps {
                sh 'node --check src/app.js'
            }
        }
    }
}
```

Benefits of Pipeline as Code include:

- version control
- reviewability
- reproducibility
- auditability
- easier collaboration

---

# Declarative vs Scripted Jenkins Pipelines

The lab used a **Declarative Pipeline**.

Example:

```groovy
pipeline {
    agent any

    stages {
        ...
    }
}
```

Declarative pipelines provide a structured pipeline syntax.

Scripted pipelines provide greater flexibility through Groovy programming but can be more complex.

For many standard CI/CD workflows, Declarative Pipeline is easier to read and maintain.

---

# `agent any`

The Jenkinsfile contained:

```groovy
agent any
```

This means Jenkins may schedule the pipeline on any eligible available agent/node.

It does **not** mean:

```text
run on every agent
```

It means:

```text
choose an appropriate available agent
```

---

# Jenkins Parameters

A choice parameter was added:

```groovy
parameters {
    choice(
        name: 'TARGET_ENV',
        choices: ['staging', 'production'],
        description: 'Select the target environment'
    )
}
```

It can be accessed using:

```groovy
${params.TARGET_ENV}
```

For example:

```groovy
stage('Deployment Selection') {
    steps {
        echo "Selected deployment environment: ${params.TARGET_ENV}"
    }
}
```

Parameters allow the same pipeline to behave differently based on controlled input.

The lab did **not** perform an actual production deployment. The parameter was used to demonstrate pipeline configuration safely.

---

# Jenkins Artifacts

Test coverage was generated using:

```bash
npm test -- --coverage
```

The resulting coverage files were archived:

```groovy
archiveArtifacts artifacts: 'coverage/**', fingerprint: true
```

This preserves pipeline output after the build.

The mental model is:

```text
Tests
  |
  v
coverage/
  |
  v
archiveArtifacts
  |
  v
Jenkins build artifact
```

`fingerprint: true` allows Jenkins to record fingerprints for archived files, helping track artifacts.

---

# Jenkins Credentials

Sensitive values should be stored in Jenkins Credentials rather than hardcoded into a `Jenkinsfile`.

Examples include:

```text
Git credentials
API tokens
SSH keys
cloud credentials
passwords
```

For a public GitHub repository, anonymous cloning may work.

For a private repository, Jenkins normally requires appropriate credentials, such as:

- personal access credentials/token
- SSH credentials

The secret itself should not appear directly in pipeline source code.

---

# Poll SCM

Jenkins can detect repository changes using Poll SCM.

The lab configured:

```text
H/5 * * * *
```

This tells Jenkins to periodically check the repository approximately every five minutes using a Jenkins-selected hashed offset.

The `H` helps distribute polling times rather than making many Jenkins jobs poll at exactly the same second.

Conceptually:

```text
Jenkins
   |
every few minutes
   |
   v
GitHub
   |
Changed?
   |
Yes → Build
No  → Do nothing
```

A test commit was merged without clicking **Build Now**, and Jenkins detected the repository change and started the pipeline automatically.

---

# GitHub Webhooks

The lab then replaced Poll SCM with a GitHub webhook trigger.

A webhook reverses the direction of communication.

Instead of Jenkins repeatedly asking GitHub:

```text
Anything changed?
Anything changed?
Anything changed?
```

GitHub tells Jenkins when an event occurs.

```text
GitHub
   |
Push/Merge event
   |
HTTP request
   v
Jenkins webhook endpoint
   |
SCM evaluation
   |
Relevant branch changed?
   |
Yes → Build
```

The Jenkins endpoint used the GitHub webhook path:

```text
/github-webhook/
```

The Jenkins job was configured with the GitHub hook trigger for Git SCM polling.

---

# HTTP 200 Does Not Guarantee a Build

One important experiment involved pushing a change to a feature branch.

GitHub's webhook delivery returned:

```text
HTTP 200
```

but Jenkins did not build the application.

This was expected because the Jenkins job was configured to build:

```text
*/main
```

The event concerned a different branch.

After the Pull Request was merged into `main`, another webhook was sent and Jenkins started the pipeline.

This demonstrates:

> HTTP 200 means the webhook request was successfully received/accepted. It does not mean every webhook event must produce a build.

The repository and branch configuration still determine whether the event is relevant.

---

# Securing the Jenkins Webhook Lab

Jenkins was not intentionally exposed on port 8080 to the entire Internet.

For the temporary lab, inbound access was restricted using AWS Security Group rules.

GitHub webhook IPv4 ranges were obtained from GitHub's metadata rather than permanently assuming fixed addresses.

Example retrieval command used during the lab:

```bash
curl -s https://api.github.com/meta | jq -r '.hooks[]'
```

Important:

> Provider IP ranges can change. They should be retrieved or verified rather than memorized and treated as permanent.

For production Jenkins environments, additional controls such as HTTPS, a reverse proxy/load balancer, authentication, secret validation, network restrictions, and least-privilege access should be considered.

---

# Webhook vs Poll SCM

## Poll SCM

```text
Jenkins → Git provider
```

Jenkins periodically checks whether something changed.

Advantages:

- works when inbound webhook access is difficult
- simple fallback mechanism

Disadvantages:

- repeated checks
- changes may not be detected immediately

## Webhook

```text
Git provider → Jenkins
```

The Git provider sends an event when something happens.

Advantages:

- event-driven
- usually faster
- avoids unnecessary periodic repository checks

A webhook is generally preferred when the source-control platform can securely reach Jenkins.

Poll SCM is useful when inbound webhook connectivity is unavailable or impractical.

---

# Jenkins Executor Troubleshooting

One of the most valuable troubleshooting exercises occurred when Jenkins displayed:

```text
Still waiting to schedule task
Waiting for next available executor
```

Initially, the application itself was not the problem.

The Jenkins built-in node was offline.

Jenkins reported that free temporary space was below its configured threshold.

The system was investigated with:

```bash
df -h
```

and:

```bash
df -h /tmp
```

The root filesystem had plenty of space.

However, `/tmp` was mounted separately as `tmpfs`.

This was confirmed with:

```bash
findmnt /tmp
```

Memory was inspected with:

```bash
free -h
```

The important finding was:

```text
/tmp tmpfs capacity ≈ 953 MiB
Jenkins minimum free-space threshold = 1 GiB
```

Therefore, even with `/tmp` almost completely empty, it could **never** satisfy a requirement for at least 1 GiB of free space.

Conceptually:

```text
/tmp maximum capacity
      953 MiB
         <
Jenkins required free space
       1 GiB
```

Jenkins consequently marked the node unavailable for builds.

For the temporary lab, the threshold was adjusted to an appropriate value for the small environment, the node returned online, an executor became available, and the existing pipeline continued successfully.

This was not primarily:

```text
an application bug
```

or:

```text
a full root disk
```

It was a Jenkins node-monitoring/resource-threshold issue.

---

# Executor Troubleshooting Method

When Jenkins reports:

```text
Waiting for next available executor
```

a useful investigation sequence is:

```text
1. Check node status
2. Check available executors
3. Determine whether node is offline
4. Read the offline reason
5. Check Jenkins node monitors
6. Check CPU, memory and disk
7. Check /tmp and other relevant filesystems
8. Correct the root cause
9. Bring node online if appropriate
10. Verify pipeline execution
```

Useful Linux commands include:

```bash
df -h
free -h
findmnt
ps aux
systemctl status jenkins
```

The key lesson is:

> Do not immediately increase executor counts when Jenkins says no executor is available. First determine why existing executors cannot accept work.

---

# GitHub Actions vs Jenkins

Both GitHub Actions and Jenkins can implement CI/CD, but their operating models differ.

| Area | GitHub Actions | Jenkins |
|---|---|---|
| Pipeline definition | YAML workflow | Jenkinsfile |
| Execution machine | Runner | Agent/node |
| Work capacity | Runner availability | Executors |
| Secrets | GitHub Secrets | Jenkins Credentials |
| Artifacts | Upload/download artifact actions | `archiveArtifacts` |
| Trigger | GitHub events | Webhooks, SCM polling, schedules, etc. |
| Hosted option | GitHub-hosted runners | Jenkins infrastructure normally managed by user/org |
| Repository integration | Native GitHub integration | Supports many SCM/platform configurations |

A useful analogy is:

```text
GitHub Actions runner ≈ Jenkins agent
```

although their management models can be different.

---

# GitHub-Hosted Runner vs EC2 Self-Hosted Runner

There are two different ways EC2 can appear in a GitHub Actions architecture.

## GitHub-hosted CI with EC2 as Deployment Target

```text
GitHub
   |
GitHub-hosted runner
   |
Build/Test
   |
Deploy
   v
EC2 application server
```

Here EC2 hosts the application.

It is **not** the CI runner.

## EC2 as a Self-Hosted GitHub Actions Runner

```text
GitHub
   |
assign job
   v
EC2 self-hosted runner
   |
Build/Test/Deploy
```

Here EC2 executes the GitHub Actions job itself.

Self-hosted runners can be useful when CI requires:

- private network access
- specialized software
- custom hardware
- greater control over execution environments

---

# CI/CD Troubleshooting Method

A pipeline should be troubleshot systematically.

A useful approach carried over from Day 1 is:

```text
OBSERVE
   ↓
IDENTIFY THE FAILED LAYER
   ↓
GATHER EVIDENCE
   ↓
FORM A HYPOTHESIS
   ↓
TEST
   ↓
IDENTIFY ROOT CAUSE
   ↓
FIX
   ↓
VERIFY
```

For CI/CD, first determine whether the problem is in:

```text
Trigger
  ↓
Pipeline configuration
  ↓
Runner / Agent / Executor
  ↓
Checkout
  ↓
Dependencies
  ↓
Tests
  ↓
Security
  ↓
Build
  ↓
Artifact
  ↓
Deployment
```

This prevents debugging the wrong layer.

---

# Practical Troubleshooting Examples

## Pipeline Never Started

Investigate:

```text
Trigger configuration
Branch filters
Webhook delivery
Workflow trigger
Jenkins SCM configuration
```

## Job Waiting for Runner

Investigate:

```text
Runner availability
CI provider status
Account/organization limits
Self-hosted runner health
```

Do not start with application debugging if the application has not executed.

## Jenkins Waiting for Executor

Investigate:

```text
Node status
Executor availability
Offline reason
Disk
/tmp
Memory
Node monitors
```

## Tests Fail

Investigate:

```text
Test logs
Dependency versions
Environment variables
Runtime versions
Missing services
Differences between local and CI environments
```

## Security Job Fails

Investigate:

```text
Scanner output
Severity threshold
Dependency versions
Known vulnerabilities
Whether remediation/update is available
```

## Deployment Skipped

Investigate:

```text
if condition
event type
branch/ref
needs dependencies
environment rules
```

---

# Common Interview Questions and Answers

## 1. What is Git?

Git is a distributed version-control system used to track changes to files and source code. It allows developers to work with branches, maintain history, collaborate, and safely integrate changes.

---

## 2. What is the staging area?

The staging area contains changes selected for the next commit.

```bash
git add file
```

moves a change into the staging area.

```bash
git commit
```

records the staged snapshot in the local repository.

---

## 3. What is the difference between Git and GitHub?

Git is the version-control system.

GitHub is a platform that hosts Git repositories and adds collaboration features such as Pull Requests, Issues, Actions, and repository management.

---

## 4. What is a branch?

A branch is a movable reference to a line of development. It allows work to happen independently before changes are integrated into another branch.

---

## 5. What is a merge conflict?

A merge conflict occurs when Git cannot automatically determine how different changes should be combined.

I resolve it by inspecting the conflicting content, deciding the correct final version, editing the file, staging the resolved file with `git add`, and completing the merge.

---

## 6. What is the difference between `git fetch` and `git pull`?

`git fetch` retrieves remote updates without automatically integrating them into my current branch.

`git pull` retrieves remote changes and integrates them into the current branch.

---

## 7. What is a Pull Request?

A Pull Request proposes integrating changes from one branch into another. It provides a place for review, automated checks, discussion, and approval before merging.

---

## 8. What is CI?

Continuous Integration is the practice of frequently integrating code changes into a shared repository and automatically validating them using checks such as tests, security scans, and builds.

---

## 9. Continuous Delivery vs Continuous Deployment?

Continuous Delivery keeps software in a release-ready state but can require approval before production.

Continuous Deployment automatically deploys changes that successfully pass the required pipeline gates.

---

## 10. What is a GitHub Actions runner?

A runner is the machine or execution environment that runs a GitHub Actions job.

---

## 11. What is a Jenkins agent?

A Jenkins agent is a node/environment capable of executing work assigned by the Jenkins controller.

---

## 12. What is an executor?

An executor is a Jenkins execution slot on a node. It represents the node's capacity to run Jenkins work.

---

## 13. What is Pipeline as Code?

Pipeline as Code means storing CI/CD pipeline configuration in version control alongside the application.

For Jenkins this commonly uses:

```text
Jenkinsfile
```

For GitHub Actions:

```text
.github/workflows/*.yml
```

This makes pipelines versioned, reviewable, reproducible, and auditable.

---

## 14. What is a webhook?

A webhook is an HTTP notification sent by one system to another when an event occurs.

For example:

```text
GitHub push
   ↓
Webhook
   ↓
Jenkins
   ↓
Pipeline
```

---

## 15. Webhook vs Poll SCM?

A webhook is event-driven: GitHub informs Jenkins when an event occurs.

Poll SCM is check-driven: Jenkins periodically checks the repository.

I would generally prefer a webhook when secure inbound connectivity is available because it reacts quickly without repeated polling.

---

## 16. What is an artifact?

An artifact is output generated by a pipeline that is preserved after execution, such as a coverage report, compiled package, or test report.

---

## 17. Artifact vs cache?

An artifact preserves pipeline output.

A cache primarily improves future pipeline performance by reusing data.

---

## 18. Why use `npm ci` in CI?

`npm ci` installs dependencies based on the lock file and is designed for clean, reproducible automated environments.

---

## 19. Where should pipeline secrets be stored?

Secrets should be stored using the CI/CD platform's secret-management mechanism, such as GitHub Secrets or Jenkins Credentials, rather than being hardcoded into source code or pipeline files.

---

## 20. Why might a pipeline pass locally but fail in CI?

I would compare:

- runtime versions
- dependency versions
- environment variables
- secrets
- operating-system differences
- file paths and permissions
- network/service dependencies
- clean-install behavior
- CI logs and exit codes

I would first identify the failing stage and use its logs as evidence before making changes.

---

# Day 2 Final Review Questions

These questions can be used later for revision without repeating the entire lab.

## Git

1. What are the working directory, staging area, local repository, and remote repository?
2. What does `git add` actually do?
3. What is a commit?
4. What does `HEAD` represent?
5. What is the purpose of a branch?
6. What does `git switch -c` do?
7. What causes a merge conflict?
8. How do you tell Git that a conflict has been resolved?
9. What is `origin`?
10. What does `git push -u` do?
11. What is the difference between `git fetch` and `git pull`?
12. When would you use `git revert` rather than rewriting history?
13. What is a Pull Request?

## GitHub Actions

14. What is a workflow?
15. What is a job?
16. What is a step?
17. What is a runner?
18. What is the difference between `uses` and `run`?
19. What does `needs` do?
20. Does `needs` automatically transfer files?
21. What is an artifact?
22. What is a cache?
23. What is the difference between an environment variable and a secret?
24. Why should secrets not be hardcoded?
25. What is a security gate?
26. Why might a deployment job be skipped?
27. What does `github.ref` represent?
28. Why should a Pull Request usually run CI before being merged?

## Jenkins

29. What does the Jenkins controller do?
30. What is an agent?
31. What is an executor?
32. What does `agent any` mean?
33. What is a `Jenkinsfile`?
34. What is Pipeline as Code?
35. What are Jenkins Credentials used for?
36. What are Jenkins parameters?
37. What does `archiveArtifacts` do?
38. What is Poll SCM?
39. What does `H/5 * * * *` mean conceptually?
40. What is a webhook?
41. Why can a webhook return HTTP 200 without starting a build?
42. When would you prefer Poll SCM instead of a webhook?

## Troubleshooting

43. Jenkins says `Waiting for next available executor`. What should you inspect first?
44. Why was increasing the executor count not the correct first solution in the lab?
45. Why could `/tmp` never satisfy Jenkins' original 1 GiB threshold?
46. GitHub Actions says `Waiting for a hosted runner to come online`. Should you debug `npm test` immediately?
47. If Test succeeds but Security fails and Build requires both, what happens to Build?
48. If a workflow is valid but a job is skipped, what conditions would you investigate?
49. If a pipeline works locally but fails in CI, what environmental differences would you check?
50. Why is identifying the failed layer important before attempting a fix?

---

# CI/CD Interview Scenario

A concise way to describe the hands-on work from this lab:

> I built a small Node.js CI/CD lab to refresh my Git and pipeline skills. I used feature branches and Pull Requests, configured GitHub Actions to install dependencies, run automated tests with coverage, perform dependency security checks, validate the application, handle secrets, archive artifacts, and control a simulated staging deployment.
>
> I also created a Jenkins environment on a temporary AWS EC2 instance and defined the pipeline using a Jenkinsfile. I tested both Poll SCM and GitHub webhook triggers, added parameters and archived coverage artifacts, and troubleshot an executor scheduling problem caused by Jenkins' temporary-space threshold being larger than the capacity of the `/tmp` tmpfs filesystem.
>
> The exercise reinforced both CI/CD implementation and troubleshooting: checking the trigger, runner or agent, dependencies, tests, security gates, artifacts, and deployment conditions rather than assuming every pipeline failure is an application problem.

This answer should be adapted naturally in an interview rather than memorized word-for-word.

---

# Commands Quick Reference

```bash
# Repository status
git status

# Stage changes
git add <file>

# Commit
git commit -m "message"

# History
git log --oneline --graph --decorate --all

# Create branch
git switch -c feature/example

# Switch branch
git switch main

# Push branch
git push -u origin feature/example

# Update local main
git switch main
git pull

# Download remote changes
git fetch

# Show remotes
git remote -v

# Show differences
git diff
git diff --staged

# Restore working-directory file
git restore <file>

# Unstage file
git restore --staged <file>

# Node dependency installation for CI
npm ci

# Tests
npm test

# Tests with coverage
npm test -- --coverage

# Dependency security audit
npm audit --audit-level=high

# Validate JavaScript syntax
node --check src/app.js

# Linux/Jenkins troubleshooting
df -h
df -h /tmp
findmnt /tmp
free -h
systemctl status jenkins
```

---

# Key Takeaways

Day 2 connected Git fundamentals with real CI/CD automation.

The most important mental model is:

```text
Developer
   |
Feature Branch
   |
Commit
   |
Push
   |
Pull Request
   |
CI
   |
   +--> Test
   +--> Security
   +--> Validate/Build
   |
Merge
   |
main
   |
Deployment workflow
```

For Jenkins:

```text
GitHub
   |
Webhook
   |
Jenkins Controller
   |
Agent / Node
   |
Executor
   |
Pipeline
   |
Test → Security → Build → Artifact → Deployment Logic
```

The biggest troubleshooting lesson was:

> Do not start by guessing the fix. First determine which layer is failing.

A CI/CD problem can come from:

```text
Git
Trigger
Workflow configuration
Runner
Jenkins node
Executor
Disk or memory
Dependencies
Tests
Security checks
Artifacts
Deployment conditions
Network access
Credentials
```

Understanding the complete path makes troubleshooting much faster than treating every failure as an application bug.

---

## Day 2 Status

**Completed: Git + GitHub + CI/CD**

Hands-on work completed:

- Git fundamentals
- Branching
- Merge conflict resolution
- Git remotes
- Pull Requests
- Node.js test application
- GitHub Actions
- Automated testing
- Test coverage
- Security checks
- Secrets
- Artifacts
- Job dependencies
- Conditional deployment
- Jenkins on AWS EC2
- Jenkins Pipeline as Code
- Jenkins parameters
- Jenkins artifacts
- Poll SCM
- GitHub webhooks
- AWS Security Group considerations
- Jenkins executor troubleshooting
- GitHub-hosted runner troubleshooting
- Cloud lab cleanup

**Next: Day 3 — Docker**