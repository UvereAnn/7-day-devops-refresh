# Day 2 — Git, GitHub & CI/CD

> **Goal:** Learn how code moves from a developer's computer through version control, automated testing, security checks, CI/CD pipelines, and deployment workflows.

---

# Table of Contents

1. [What You Will Learn](#what-you-will-learn)
2. [The Big Picture](#the-big-picture)
3. [Part 1 — Git Fundamentals](#part-1--git-fundamentals)
4. [Part 2 — Branching and Merging](#part-2--branching-and-merging)
5. [Part 3 — GitHub and Remote Repositories](#part-3--github-and-remote-repositories)
6. [Part 4 — Pull Requests](#part-4--pull-requests)
7. [Part 5 — Build the Node.js Application](#part-5--build-the-nodejs-application)
8. [Part 6 — Understanding CI/CD](#part-6--understanding-cicd)
9. [Part 7 — GitHub Actions](#part-7--github-actions)
10. [Part 8 — Multi-Job CI Pipeline](#part-8--multi-job-ci-pipeline)
11. [Part 9 — Artifacts, Secrets and Environments](#part-9--artifacts-secrets-and-environments)
12. [Part 10 — CI/CD Troubleshooting](#part-10--cicd-troubleshooting)
13. [Part 11 — Jenkins Fundamentals](#part-11--jenkins-fundamentals)
14. [Part 12 — Jenkins Locally on Ubuntu](#part-12--jenkins-locally-on-ubuntu)
15. [Part 13 — Jenkins Pipeline as Code](#part-13--jenkins-pipeline-as-code)
16. [Part 14 — Poll SCM](#part-14--poll-scm)
17. [Part 15 — Jenkins on AWS EC2](#part-15--jenkins-on-aws-ec2)
18. [Part 16 — GitHub Webhooks](#part-16--github-webhooks)
19. [Part 17 — Jenkins Parameters, Credentials and Artifacts](#part-17--jenkins-parameters-credentials-and-artifacts)
20. [Part 18 — Jenkins Troubleshooting](#part-18--jenkins-troubleshooting)
21. [Part 19 — GitHub Actions vs Jenkins](#part-19--github-actions-vs-jenkins)
22. [Part 20 — Interview Preparation](#part-20--interview-preparation)
23. [Final Review Questions](#final-review-questions)
24. [Command Cheat Sheet](#command-cheat-sheet)

---

# What You Will Learn

By the end of Day 2, you should be able to explain and demonstrate:

- Git and version control
- Working directory, staging area and repository
- Git commits
- Git branches
- Merging
- Merge conflicts
- Local and remote repositories
- GitHub
- Pull Requests
- `git fetch` vs `git pull`
- CI/CD
- Continuous Integration
- Continuous Delivery
- Continuous Deployment
- GitHub Actions
- Workflows
- Events and triggers
- Jobs
- Steps
- Runners
- Environment variables
- Secrets
- Artifacts
- Job dependencies
- Security gates
- Conditional deployment
- Jenkins
- Jenkins controllers, agents and executors
- Jenkinsfiles
- Pipeline as Code
- Poll SCM
- GitHub webhooks
- Jenkins parameters
- Jenkins credentials
- Jenkins artifacts
- CI/CD troubleshooting

Most importantly, you will build a real project while learning these concepts.

---

# The Big Picture

Before touching Git commands, understand where Day 2 fits into DevOps.

A developer may write code locally:

```text
Developer
   |
   v
Source Code
```

But professional software development requires much more than writing code.

We need to answer questions such as:

- Who changed the code?
- What changed?
- Why was it changed?
- Can we restore an older version?
- Can multiple developers work safely?
- Has the code been tested?
- Does it contain known vulnerable dependencies?
- Should it be deployed?
- Can deployment happen automatically?

This creates a workflow:

```text
Developer
    |
    v
Git
    |
    v
GitHub
    |
    v
Pull Request
    |
    v
CI Pipeline
    |
    +---- Tests
    |
    +---- Security Checks
    |
    +---- Build
    |
    v
Deployment
```

Git manages the history of the code.

GitHub provides collaboration around Git repositories.

CI/CD automates validation and delivery of changes.

---

# Part 1 — Git Fundamentals

# 1. What Is Version Control?

Version control is a system for tracking changes to files over time.

Imagine editing a project without Git:

```text
project-final
project-final2
project-final-correct
project-final-correct-new
project-final-REAL-final
```

This becomes difficult to manage.

Git solves this by maintaining a history.

```text
Version 1
   |
Version 2
   |
Version 3
   |
Version 4
```

Each saved point in Git is called a **commit**.

---

# 2. What Is Git?

Git is a distributed version control system.

It allows developers to:

- track changes
- create versions of code
- collaborate
- create branches
- merge changes
- compare versions
- recover older versions
- investigate when changes were introduced

Git works locally.

You do **not** need GitHub to use Git.

This distinction is important:

```text
Git
=
Version control software

GitHub
=
Online platform that hosts Git repositories
```

---

# 3. The Git Mental Model

One of the most important Git concepts is understanding the three main areas.

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

These are the files you are currently editing.

## Staging Area

The staging area contains changes you have selected for the next commit.

## Local Repository

The local repository contains committed history.

## Remote Repository

A remote repository is normally hosted somewhere such as GitHub.

---

# Practical 1 — Create the Learning Project

We will use one repository throughout Day 2.

Open your terminal.

```bash
cd ~
mkdir devops-cicd-lab
cd devops-cicd-lab
```

Check your location:

```bash
pwd
```

Create a README:

```bash
echo "# DevOps CI/CD Lab" > README.md
```

Check the directory:

```bash
ls
```

You should see:

```text
README.md
```

---

# Initialize Git

Run:

```bash
git init
```

Git creates a hidden directory:

```text
.git/
```

Check it:

```bash
ls -la
```

The `.git` directory contains Git's internal repository data.

Without `.git`, this directory is just a normal directory.

With `.git`, it becomes a Git repository.

---

# Check Repository State

Run:

```bash
git status
```

You should see `README.md` listed as an **untracked file**.

What does untracked mean?

Git sees the file, but the file has never been added to Git's tracked history.

---

# Stage the File

Run:

```bash
git add README.md
```

Then:

```bash
git status
```

Notice the change.

Before:

```text
Untracked files
```

After:

```text
Changes to be committed
```

The file has moved conceptually from:

```text
Working Directory
       |
       | git add
       v
Staging Area
```

---

# Make Your First Commit

Run:

```bash
git commit -m "docs: add initial README"
```

A commit is a snapshot of the staged changes.

Check history:

```bash
git log
```

For a shorter view:

```bash
git log --oneline
```

You may see something similar to:

```text
a1b2c3d docs: add initial README
```

The characters such as:

```text
a1b2c3d
```

are part of the commit hash.

Git uses hashes to uniquely identify commits.

---

# 4. Understanding HEAD

`HEAD` normally points to the commit currently checked out.

Conceptually:

```text
commit A
   |
commit B
   |
commit C
   ^
   |
  HEAD
```

You can inspect the latest commit:

```bash
git show HEAD
```

---

# 5. Understanding git diff

Modify the README:

```bash
echo "Hands-on repository for learning Git and CI/CD." >> README.md
```

Run:

```bash
git status
```

Then:

```bash
git diff
```

`git diff` shows changes in your working directory that have **not yet been staged**.

Now stage the file:

```bash
git add README.md
```

Run:

```bash
git diff
```

You may now see nothing.

Why?

Because the change is no longer an unstaged working-directory change.

Run:

```bash
git diff --staged
```

Now you can see the staged change.

Remember:

```text
git diff
=
Working Directory vs Staging Area

git diff --staged
=
Staging Area vs Last Commit
```

Commit:

```bash
git commit -m "docs: describe CI/CD lab"
```

---

# 6. .gitignore

Some files should not be committed.

Examples include:

```text
node_modules/
coverage/
.env
temporary files
logs
```

Create `.gitignore`:

```bash
cat > .gitignore <<'EOF'
node_modules/
coverage/
.env
*.log
EOF
```

Stage and commit:

```bash
git add .gitignore
git commit -m "chore: add gitignore"
```

---

# 7. Undoing Changes

Git provides several ways to undo changes.

## Restore an unstaged file

```bash
git restore filename
```

This discards working-directory modifications.

Be careful: the uncommitted modification will be lost.

## Unstage a file

```bash
git restore --staged filename
```

This removes the file from staging without deleting your working-directory change.

## Revert a commit

```bash
git revert <commit>
```

`git revert` creates a **new commit** that reverses an older commit.

This is usually safer for shared history.

## Reset

`git reset` moves Git references and can rewrite local history depending on the mode.

For example:

```bash
git reset --soft HEAD~1
```

and:

```bash
git reset --hard HEAD~1
```

behave very differently.

`--hard` can destroy uncommitted work.

For shared repositories, understand the consequences before rewriting history.

---

# Knowledge Check

Before continuing, make sure you can explain:

1. What is Git?
2. What is a commit?
3. What is the staging area?
4. What does `git add` do?
5. What does `git commit` do?
6. What is HEAD?
7. What is the difference between `git diff` and `git diff --staged`?
8. Why do we use `.gitignore`?

---

# Part 2 — Branching and Merging

# 8. What Is a Branch?

A branch allows development to continue separately from another line of development.

Imagine:

```text
A --- B --- C    main
           \
            D --- E    feature/login
```

The feature developer can work on `feature/login` without immediately changing `main`.

---

# Why Branches Matter

Branches allow teams to:

- develop features independently
- fix bugs safely
- review changes
- test before merging
- protect the main branch

---

# Practical 2 — Create a Feature Branch

Check your current branch:

```bash
git branch
```

Create and switch to a new branch:

```bash
git switch -c feature/homepage
```

This combines:

```text
create branch
+
switch to branch
```

Verify:

```bash
git branch
```

The `*` identifies your current branch.

---

# Make a Change

Create the application directory:

```bash
mkdir -p src
```

Create:

```bash
cat > src/app.js <<'EOF'
function getMessage() {
  return "DevOps CI/CD Lab";
}

module.exports = { getMessage };
EOF
```

Check:

```bash
git status
```

Stage and commit:

```bash
git add src/app.js
git commit -m "feat: add application module"
```

---

# Switch Back to Main

```bash
git switch main
```

Check:

```bash
ls src
```

Depending on the previous repository state, the feature file will not be part of `main` yet.

The commit belongs to the feature branch.

---

# Merge the Feature

```bash
git merge feature/homepage
```

Now the feature becomes part of `main`.

---

# Fast-Forward Merge

If `main` has not changed since the feature branch was created, Git may perform a fast-forward merge.

Before:

```text
A --- B    main
       \
        C --- D    feature
```

After:

```text
A --- B --- C --- D
                  ^
                  |
                 main
```

Git simply moves the `main` pointer forward.

---

# Practical 3 — Create a Merge Conflict

Merge conflicts are important to understand.

Create a branch:

```bash
git switch -c feature/message
```

Edit `src/app.js` so the message becomes:

```javascript
return "Message from feature branch";
```

Commit:

```bash
git add src/app.js
git commit -m "feat: update application message"
```

Switch to main:

```bash
git switch main
```

Edit the **same line** differently:

```javascript
return "Message from main branch";
```

Commit:

```bash
git add src/app.js
git commit -m "feat: update main application message"
```

Now merge:

```bash
git merge feature/message
```

Git may report a conflict.

Run:

```bash
git status
```

Open the conflicted file.

You may see markers similar to:

```text
<<<<<<< HEAD
return "Message from main branch";
=======
return "Message from feature branch";
>>>>>>> feature/message
```

Git is saying:

> I found two competing changes and cannot safely decide which one you want.

---

# Resolve the Conflict

Edit the file manually.

For example:

```javascript
function getMessage() {
  return "DevOps CI/CD Lab";
}

module.exports = { getMessage };
```

Save it.

Now run:

```bash
git add src/app.js
```

Why `git add`?

Because editing the file resolves the **content**, while `git add` tells Git:

> The conflict in this file has been resolved.

Complete the merge:

```bash
git commit
```

Check history:

```bash
git log --oneline --graph --decorate --all
```

This command is excellent for visualizing branches.

---

# Part 3 — GitHub and Remote Repositories

# 9. Local vs Remote Repository

So far everything has happened on your computer.

```text
Laptop
└── devops-cicd-lab
```

A remote repository allows the code to exist somewhere accessible to other developers and automation systems.

```text
Local Repository
       |
       | push
       v
Remote Repository
```

---

# 10. Create the GitHub Repository

Sign in to GitHub.

Create a new repository named:

```text
devops-cicd-lab
```

A suitable description is:

```text
Hands-on repository for learning Git, GitHub, CI/CD, GitHub Actions and Jenkins.
```

Because the local repository already contains files, avoid initializing the remote with unrelated starter files if you want the cleanest first push.

---

# 11. Add the Remote

Git does not automatically know where your GitHub repository is.

Add it:

```bash
git remote add origin <YOUR-GITHUB-REPOSITORY-URL>
```

Example structure:

```text
git remote add origin <remote-url>
```

Check:

```bash
git remote -v
```

---

# What Is origin?

`origin` is simply a conventional alias for a remote repository.

It does **not** mean GitHub.

You could theoretically write:

```bash
git remote add production <url>
```

or:

```bash
git remote add banana <url>
```

But `origin` is the common convention for the primary remote.

---

# Push Main

Ensure the branch is named `main`:

```bash
git branch -M main
```

Push:

```bash
git push -u origin main
```

Break this down:

```text
git push
│
├── -u       → set upstream tracking
├── origin   → remote name
└── main     → branch
```

After upstream tracking exists, future pushes can normally use:

```bash
git push
```

---

# 12. Fetch vs Pull

These are commonly confused.

## git fetch

```bash
git fetch
```

Downloads information from the remote but does not automatically integrate those changes into your current branch.

Conceptually:

```text
GitHub
   |
   | download information
   v
Remote-tracking references
```

## git pull

```bash
git pull
```

Conceptually performs:

```text
fetch
+
integrate
```

A useful interview answer:

> `git fetch` retrieves remote changes without automatically integrating them into my current branch, while `git pull` retrieves and then integrates remote changes.

---

# Part 4 — Pull Requests

# 13. What Is a Pull Request?

A Pull Request, or PR, is a request to review and merge changes from one branch into another.

For example:

```text
feature/health-endpoint
          |
          | Pull Request
          v
         main
```

A PR provides a place for:

- code review
- automated CI checks
- discussion
- approvals
- change history

---

# Practical 4 — Feature Branch to Pull Request

Create a branch:

```bash
git switch -c feature/health-endpoint
```

Create or modify a file.

Commit:

```bash
git add .
git commit -m "feat: add health endpoint"
```

Push:

```bash
git push -u origin feature/health-endpoint
```

Open GitHub.

Create a Pull Request:

```text
base: main
compare: feature/health-endpoint
```

This means:

> Show the changes from `feature/health-endpoint` that we want to merge into `main`.

---

# What Happens If You Push Another Commit?

Suppose the PR is still open.

Make another change:

```bash
git add .
git commit -m "fix: improve health endpoint"
git push
```

You do **not** need another Pull Request.

The existing PR automatically includes the new commit because the PR compares branches.

---

# After Merge

Once the PR is merged on GitHub:

```bash
git switch main
git pull
```

Your local `main` now catches up with remote `main`.

---

# Part 5 — Build the Node.js Application

We need an application that our CI/CD pipeline can test.

---

# 14. Initialize Node.js

From the project root:

```bash
npm init -y
```

This creates:

```text
package.json
```

`package.json` describes the Node.js project and its dependencies.

---

# Install Express

```bash
npm install express
```

Install testing dependencies:

```bash
npm install --save-dev jest supertest
```

---

# 15. Create the Application

Create `src/app.js`:

```javascript
const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.status(200).send('DevOps CI/CD Lab');
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok'
  });
});

module.exports = app;
```

---

# Create the Server

Create `src/server.js`:

```javascript
const app = require('./app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
```

Notice:

```javascript
process.env.PORT || 3000
```

This means:

```text
If PORT environment variable exists
        ↓
use it

Otherwise
        ↓
use 3000
```

This pattern becomes especially important later when working with containers and cloud platforms.

---

# Configure package.json

Ensure your scripts include:

```json
"scripts": {
  "start": "node src/server.js",
  "test": "jest"
}
```

---

# Run the Application

```bash
npm start
```

In another terminal:

```bash
curl http://localhost:3000/
```

Then:

```bash
curl http://localhost:3000/health
```

Expected health response:

```json
{
  "status": "ok"
}
```

Stop the server with:

```text
Ctrl+C
```

---

# 16. Add Automated Tests

Create:

```text
tests/app.test.js
```

Add:

```javascript
const request = require('supertest');
const app = require('../src/app');

describe('Application endpoints', () => {
  test('GET / returns 200', async () => {
    const response = await request(app).get('/');

    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('DevOps CI/CD Lab');
  });

  test('GET /health returns healthy status', async () => {
    const response = await request(app).get('/health');

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('ok');
  });
});
```

Run:

```bash
npm test
```

You should have two tests.

Generate coverage:

```bash
npm test -- --coverage
```

This creates:

```text
coverage/
```

Because `coverage/` is in `.gitignore`, it should not be committed.

---

# Why Automated Tests Matter to CI

Without automated tests:

```text
Developer
   |
   v
"I think it works."
```

With automated tests:

```text
Developer pushes code
        |
        v
CI runs tests
        |
   +----+----+
   |         |
 PASS       FAIL
   |         |
continue    stop
```

This is one of the foundations of Continuous Integration.

---

# Commit the Application

```bash
git add .
git commit -m "feat: add Node.js application and tests"
git push
```

---

# Part 6 — Understanding CI/CD

# 17. What Is CI?

CI means:

```text
Continuous Integration
```

Developers frequently integrate changes into a shared repository, while automated systems validate those changes.

A simple CI pipeline might be:

```text
Push Code
   |
   v
Install Dependencies
   |
   v
Run Tests
   |
   v
Security Check
   |
   v
Validate Build
```

CI gives fast feedback.

---

# 18. Continuous Delivery

Continuous Delivery means the software is automatically validated and kept in a deployable state, but production deployment normally requires a deliberate decision or approval.

```text
Code
 ↓
CI
 ↓
Build
 ↓
Deployable Artifact
 ↓
Manual Approval
 ↓
Production
```

---

# 19. Continuous Deployment

Continuous Deployment goes further.

If all required checks pass, the software can automatically move into production.

```text
Code
 ↓
CI
 ↓
Tests
 ↓
Security
 ↓
Build
 ↓
Production
```

No manual production approval is required in a fully automated continuous-deployment model.

---

# CI vs Delivery vs Deployment

Remember:

```text
Continuous Integration
=
Automatically validate integrated code.

Continuous Delivery
=
Automatically prepare validated changes so they are ready for release.

Continuous Deployment
=
Automatically release validated changes to production.
```

---

# Part 7 — GitHub Actions

# 20. What Is GitHub Actions?

GitHub Actions is GitHub's automation platform.

It can react to repository events such as:

```text
push
pull_request
workflow_dispatch
schedule
release
```

and execute workflows.

---

# Core Architecture

```text
Event
  |
  v
Workflow
  |
  +------ Job A
  |         |
  |         +-- Step
  |         +-- Step
  |
  +------ Job B
            |
            +-- Step
            +-- Step
```

---

# 21. Workflow

A workflow is an automated process defined using YAML.

Workflow files live under:

```text
.github/workflows/
```

---

# 22. Job

A workflow contains one or more jobs.

Example:

```text
CI Workflow
├── test
├── security
└── build
```

Jobs can run independently or depend on other jobs.

---

# 23. Step

A job contains steps.

Example:

```text
Test Job
├── Checkout
├── Setup Node
├── Install dependencies
└── Run tests
```

---

# 24. Runner

A runner is the machine that executes a job.

For example:

```yaml
runs-on: ubuntu-latest
```

means GitHub provides an Ubuntu runner for that job.

Important:

```text
Your Laptop
     ≠
GitHub Runner
```

Your code is checked out onto a separate execution environment.

---

# Practical 5 — First GitHub Actions Workflow

Create:

```bash
mkdir -p .github/workflows
```

Create:

```text
.github/workflows/ci.yml
```

Start with:

```yaml
name: Node.js CI

on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Setup Node.js
        uses: actions/setup-node@v7
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test
```

Commit:

```bash
git add .github/workflows/ci.yml
git commit -m "ci: add GitHub Actions workflow"
git push
```

Open the **Actions** tab on GitHub.

Watch the workflow.

---

# 25. uses vs run

These are important.

## uses

Example:

```yaml
uses: actions/checkout@v6
```

This uses an existing GitHub Action.

## run

Example:

```yaml
run: npm test
```

This executes a shell command on the runner.

Remember:

```text
uses
=
use an existing Action

run
=
execute a command
```

---

# 26. Why Checkout Is Required

The runner starts as a fresh execution environment.

It does not automatically contain your repository.

Therefore:

```yaml
uses: actions/checkout@v6
```

downloads the repository into the runner workspace.

---

# 27. Why Setup Node Is Required

Our application requires Node.js.

```yaml
uses: actions/setup-node@v7
```

ensures the desired Node.js environment is available.

---

# 28. npm install vs npm ci

During development you commonly use:

```bash
npm install
```

In CI we generally prefer:

```bash
npm ci
```

when a valid `package-lock.json` exists.

`npm ci` performs a clean dependency installation based on the lock file.

This improves reproducibility.

---

# Part 8 — Multi-Job CI Pipeline

A real CI pipeline should teach us job dependencies.

We will create:

```text
           Test
             \
              \
               > Build
              /
             /
        Security
```

Test and Security can run independently.

Build should run only after both succeed.

---

# Practical 6 — Add Security and Build Jobs

Update `ci.yml`.

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

jobs:

  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Setup Node.js
        uses: actions/setup-node@v7
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run tests with coverage
        run: npm test -- --coverage


  security:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Setup Node.js
        uses: actions/setup-node@v7
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Audit dependencies
        run: npm audit --audit-level=high


  build:
    needs:
      - test
      - security

    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Setup Node.js
        uses: actions/setup-node@v7
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Validate application
        run: node --check src/app.js
```

---

# Why Does Every Job Checkout Again?

A common beginner question is:

> Test already checked out the repository. Why does Security need to do it again?

Because GitHub-hosted jobs are isolated.

Conceptually:

```text
Test Job
└── Runner A

Security Job
└── Runner B

Build Job
└── Runner C
```

They do not automatically share filesystems.

Therefore each job prepares its own environment.

---

# 29. Understanding needs

This:

```yaml
needs:
  - test
  - security
```

creates dependencies.

```text
test --------\
              \
               ---> build
              /
security ----/
```

If Security fails:

```text
Test       PASS
Security   FAIL
Build      SKIPPED
```

This is a **pipeline gate**.

---

# Important: needs Does Not Transfer Files

`needs` controls execution order/dependency.

It does not automatically copy files from one job to another.

For transferring build output, use mechanisms such as artifacts.

---

# 30. Parallel Jobs

Because `test` and `security` do not depend on each other, they can run in parallel.

```text
           +--> Test --------+
Push ------|                 |--> Build
           +--> Security ----+
```

This is an example of a Directed Acyclic Graph, or DAG.

---

# Part 9 — Artifacts, Secrets and Environments

# 31. What Is an Artifact?

An artifact is output produced during a pipeline that you want to preserve.

Examples:

```text
compiled application
test report
coverage report
binary
package
```

Our tests generate:

```text
coverage/
```

We can preserve that after the runner disappears.

---

# Practical 7 — Upload Coverage Artifact

Add this after the test step:

```yaml
      - name: Upload coverage report
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/
```

Now:

```text
Tests
  |
  v
coverage/
  |
  v
Upload Artifact
  |
  v
Stored with workflow run
```

---

# Artifact vs Cache

These are different.

## Artifact

Preserves useful pipeline output.

Example:

```text
coverage report
build package
```

## Cache

Speeds up future workflow executions by reusing reusable data.

Example:

```text
dependency cache
```

Think:

```text
Artifact
=
output I want to keep

Cache
=
data I want to reuse for speed
```

---

# 32. Environment Variables

An environment variable provides configuration to processes.

Workflow level:

```yaml
env:
  NODE_ENV: test
```

Job level:

```yaml
jobs:
  test:
    env:
      EXAMPLE: value
```

Step level:

```yaml
- name: Example
  run: echo "$EXAMPLE"
  env:
    EXAMPLE: value
```

Prefer the smallest scope that needs the value.

---

# 33. Secrets

Sensitive values should not be hardcoded into source code or workflow files.

Examples include:

```text
API tokens
passwords
cloud credentials
private keys
```

GitHub provides repository secrets.

Create a test secret:

```text
LAB_SECRET
```

Use:

```yaml
${{ secrets.LAB_SECRET }}
```

Example safe check:

```yaml
  secret-demo:
    runs-on: ubuntu-latest

    steps:
      - name: Verify secret exists
        env:
          LAB_SECRET: ${{ secrets.LAB_SECRET }}

        run: |
          if [ -z "$LAB_SECRET" ]; then
            echo "LAB_SECRET is not configured"
            exit 1
          fi

          echo "LAB_SECRET is configured"
```

Do not intentionally print secret values.

---

# 34. GitHub Contexts

GitHub exposes contextual information.

Examples:

```yaml
${{ github.ref }}
${{ github.sha }}
${{ github.event_name }}
```

`github.ref` tells us which Git ref triggered the workflow.

`github.sha` identifies the commit.

`github.event_name` tells us the triggering event.

---

# 35. Conditional Deployment

We don't want every Pull Request to deploy.

Suppose we want staging deployment only when code reaches `main`.

Add:

```yaml
  deploy-staging:
    needs:
      - build

    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    runs-on: ubuntu-latest

    environment:
      name: staging

    steps:
      - name: Simulate staging deployment
        run: |
          echo "Deploying commit ${{ github.sha }} to staging"
```

---

# Understand the Flow

For a Pull Request:

```text
PR
 |
 +--> Test
 |
 +--> Security
 |
 +--> Build
 |
 X    Deploy
```

Deployment is skipped because the event is:

```text
pull_request
```

After merging:

```text
Merge
  |
  v
Push to main
  |
  +--> Test
  +--> Security
  +--> Build
  +--> Deploy Staging
```

---

# 36. GitHub Environments

A GitHub Environment represents a deployment target such as:

```text
development
staging
production
```

Environments can help organize deployment-specific configuration and protection.

Our example uses:

```yaml
environment:
  name: staging
```

---

# Part 10 — CI/CD Troubleshooting

A DevOps engineer should not only build pipelines.

You must know how to diagnose them.

Use the same methodology from Day 1:

```text
OBSERVE
   |
IDENTIFY THE FAILED LAYER
   |
GATHER EVIDENCE
   |
FORM A HYPOTHESIS
   |
TEST
   |
ROOT CAUSE
   |
FIX
   |
VERIFY
```

---

# Practical 8 — Break the Pipeline

## Experiment A — Incorrect Job Dependency

Change:

```yaml
needs:
  - security
```

to an incorrect job name.

Push the change on a feature branch.

Observe what GitHub reports.

Then restore the correct job ID.

### Lesson

Configuration references must match real job IDs.

---

# Experiment B — Shell Syntax Error

Introduce an invalid shell expression inside a test step.

Observe that:

```text
YAML may be valid
        |
        v
Runner starts
        |
        v
Shell executes
        |
        v
Shell syntax error
```

This is different from a YAML parsing failure.

---

# Experiment C — Incorrect Git Reference

Change:

```text
refs/heads/main
```

to:

```text
refs/head/main
```

Run the workflow.

Deployment may be skipped.

Why?

The condition evaluates to false.

The job did not necessarily fail.

This teaches an important distinction:

```text
FAILED
≠
SKIPPED
```

---

# Experiment D — YAML Indentation

Break the indentation around a job.

Push the change.

Observe the workflow configuration error.

YAML structure depends on indentation.

---

# Troubleshooting Layers

When a CI pipeline fails, determine the layer.

```text
1. Trigger
2. Workflow syntax
3. Runner allocation
4. Repository checkout
5. Runtime/tool setup
6. Dependency installation
7. Tests
8. Security checks
9. Build
10. Artifact handling
11. Deployment condition
12. Deployment
```

Do not debug layer 8 when execution never passed layer 3.

---

# Hosted Runner Example

Suppose GitHub shows:

```text
Waiting for a hosted runner to come online
```

Ask:

> Have my application tests started?

If not, debugging the Node.js application is premature.

The failure or delay is at the runner/execution infrastructure layer.

---

# Part 11 — Jenkins Fundamentals

# 37. What Is Jenkins?

Jenkins is an automation server commonly used to implement CI/CD pipelines.

Like GitHub Actions, Jenkins can:

- retrieve source code
- execute tests
- run security checks
- build applications
- create artifacts
- trigger deployments
- integrate with external systems

But the operating model is different.

With GitHub-hosted Actions runners, GitHub manages the execution infrastructure.

With Jenkins, organizations commonly manage Jenkins infrastructure themselves.

---

# 38. Jenkins Architecture

Important concepts:

```text
Jenkins Controller
       |
       +------ Agent A
       |         |
       |         +-- Executor
       |         +-- Executor
       |
       +------ Agent B
                 |
                 +-- Executor
```

---

# Controller

The controller coordinates Jenkins.

It handles things such as:

- configuration
- scheduling
- credentials
- jobs
- pipeline orchestration
- plugins
- nodes

Think:

```text
Controller
=
manager/coordinator
```

---

# Agent

An agent is a machine or environment where Jenkins can execute work.

Think:

```text
Agent
=
worker
```

---

# Executor

An executor is a work slot on a Jenkins node.

Example:

```text
Node
├── Executor 1 → Job A
└── Executor 2 → Job B
```

If both executors are busy, another build may wait.

---

# GitHub Actions vs Jenkins Mental Model

A useful approximation is:

```text
GitHub Actions Runner
        ≈
Jenkins Agent
```

They are not identical products, but both represent execution environments for pipeline work.

---

# 39. Pipeline as Code

Instead of manually defining every pipeline action in the Jenkins UI, we can store the pipeline with the source code.

Jenkins uses:

```text
Jenkinsfile
```

Benefits include:

```text
version control
code review
auditability
repeatability
change history
```

---

# Declarative Pipeline

Example:

```groovy
pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
    }
}
```

Declarative Pipeline provides a structured pipeline syntax.

---

# Scripted Pipeline

Jenkins also supports Scripted Pipeline, which provides more programmatic flexibility.

For learning and many standard pipelines, Declarative Pipeline is easier to read and maintain.

---

# Part 12 — Jenkins Locally on Ubuntu

Running Jenkins locally helps you understand that Jenkins is simply software running on a machine.

The architecture is:

```text
Browser
   |
   v
localhost:8080
   |
   v
Jenkins Service
   |
   v
Local Executor
   |
   v
Pipeline Commands
```

---

# Practical 9 — Check the Machine First

Before installing software, inspect the system.

```bash
free -h
df -h /
java -version
node --version
npm --version
git --version
ss -tuln | grep :8080
```

Why?

```text
free -h
→ memory

df -h /
→ disk

java -version
→ Java runtime

node/npm
→ application runtime

git
→ source-control client

ss
→ whether port 8080 is already listening
```

This is better than blindly installing software.

---

# Install Java

Current Jenkins releases require a supported Java runtime.

On a current Ubuntu installation:

```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre
```

Verify:

```bash
java -version
```

---

# Add the Jenkins Repository

Install the Jenkins repository signing key:

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
```

Add the LTS repository:

```bash
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

Update package information:

```bash
sudo apt update
```

Install Jenkins:

```bash
sudo apt install jenkins
```

---

# Start Jenkins

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Check:

```bash
sudo systemctl status jenkins
```

You want:

```text
active (running)
```

---

# Check Port 8080

```bash
ss -tuln | grep :8080
```

This connects Day 1 networking to Day 2 CI/CD.

```text
Jenkins process
      |
      v
TCP socket
      |
      v
port 8080
```

---

# Open Jenkins

Open:

```text
http://localhost:8080
```

Your browser communicates with Jenkins on your own machine.

```text
Browser
   |
   v
127.0.0.1:8080
   |
   v
Jenkins
```

---

# Get the Initial Admin Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Use it in the Jenkins setup page.

Install the suggested plugins.

Create your admin user.

---

# Local Jenkins Troubleshooting

If Jenkins does not open, don't immediately reinstall it.

Check:

```bash
sudo systemctl status jenkins
```

Then:

```bash
ss -tuln | grep :8080
```

Then logs:

```bash
sudo journalctl -u jenkins
```

Think:

```text
Is service running?
       |
       v
Is port listening?
       |
       v
What do logs say?
```

This is systematic troubleshooting.

---

# Part 13 — Jenkins Pipeline as Code

# Practical 10 — Create the Jenkinsfile

From `devops-cicd-lab`, create:

```text
Jenkinsfile
```

Start with:

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
                sh 'npm test'
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

    post {
        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}
```

Commit:

```bash
git add Jenkinsfile
git commit -m "ci: add Jenkins pipeline"
git push
```

---

# Understanding agent any

```groovy
agent any
```

means Jenkins can run the pipeline on any suitable available agent/node.

---

# Understanding stages

```groovy
stages {
}
```

contains the major phases of the pipeline.

Our pipeline is:

```text
Checkout
   |
Install Dependencies
   |
Test
   |
Security
   |
Validate
```

---

# Understanding steps

Inside a stage:

```groovy
steps {
    sh 'npm test'
}
```

`steps` describes work to perform.

`sh` executes a shell command.

---

# Practical 11 — Create Jenkins Pipeline Job

From Jenkins:

```text
New Item
```

Name:

```text
devops-cicd-lab
```

Choose:

```text
Pipeline
```

Under Pipeline configuration select:

```text
Pipeline script from SCM
```

SCM means:

```text
Source Code Management
```

Choose:

```text
Git
```

Enter your GitHub repository URL.

For a public repository, anonymous read access may be sufficient.

For a private repository, configure Jenkins Credentials rather than hardcoding authentication information.

Set:

```text
Branch Specifier:
*/main
```

Set:

```text
Script Path:
Jenkinsfile
```

Save.

Run:

```text
Build Now
```

---

# What Just Happened?

```text
Jenkins
   |
   v
GitHub Repository
   |
   v
Read Jenkinsfile
   |
   v
Allocate Executor
   |
   v
Checkout
   |
   v
npm ci
   |
   v
npm test
   |
   v
npm audit
   |
   v
node --check
```

---

# Part 14 — Poll SCM

# 40. What Is Polling?

Polling means Jenkins periodically asks the source-control system:

> Has anything changed?

Architecture:

```text
Jenkins
   |
   | periodically asks
   v
GitHub
   |
   +--> no relevant change → nothing
   |
   +--> relevant change → build
```

---

# Practical 12 — Configure Poll SCM

Open the Jenkins job configuration.

Under **Build Triggers**, enable:

```text
Poll SCM
```

Use:

```text
H/5 * * * *
```

This means Jenkins checks approximately every five minutes using Jenkins' hashed scheduling behavior.

`H` helps distribute jobs instead of making every Jenkins job run at exactly the same second.

---

# Test Poll SCM

Create a branch:

```bash
git switch -c feature/poll-test
```

Modify the README:

```bash
echo "Testing Jenkins Poll SCM" >> README.md
```

Commit:

```bash
git add README.md
git commit -m "test: verify Jenkins Poll SCM"
```

Push:

```bash
git push -u origin feature/poll-test
```

Create and merge the PR into `main`.

Do **not** press `Build Now`.

Wait for Jenkins polling.

If configured correctly:

```text
main changes
    |
    v
Jenkins polls GitHub
    |
    v
change detected
    |
    v
pipeline starts
```

---

# Polling Limitation

Polling repeatedly checks for changes even when there may be nothing new.

A more event-driven approach is a webhook.

---

# Part 15 — Jenkins on AWS EC2

Now move Jenkins from:

```text
Your Laptop
```

to:

```text
AWS EC2
```

This introduces real server and network concepts.

---

# Why Run Jenkins on a Server?

A local Jenkins instance depends on your laptop.

If your laptop:

```text
shuts down
disconnects
sleeps
```

Jenkins becomes unavailable.

A dedicated server provides a more appropriate environment for shared automation.

---

# Architecture

```text
Developer
    |
    v
GitHub
    |
    v
Internet
    |
    v
AWS Security Group
    |
    v
EC2 Ubuntu
    |
    v
Jenkins :8080
```

---

# Practical 13 — Create EC2

Create an Ubuntu EC2 instance.

For a learning environment, select a small instance appropriate to the workload and your AWS account/budget.

Configure SSH access from your IP.

Example:

```text
TCP 22
Source: My IP
```

Do not unnecessarily expose administrative services to the entire internet.

---

# Connect with SSH

```bash
chmod 400 <key-file>.pem
```

Connect:

```bash
ssh -i <key-file>.pem ubuntu@<EC2-PUBLIC-IP>
```

Now your shell is running commands on EC2 rather than your laptop.

Verify:

```bash
hostname
```

---

# Install Jenkins on EC2

The installation process is conceptually the same as local Ubuntu.

Install Java:

```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre
```

Verify:

```bash
java -version
```

Add Jenkins repository:

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
```

```bash
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

Install:

```bash
sudo apt update
sudo apt install jenkins
```

Start:

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Verify:

```bash
sudo systemctl status jenkins
```

---

# Check Port 8080 on the Server

```bash
ss -tuln | grep :8080
```

You may have:

```text
Jenkins running
+
port listening
```

but still be unable to reach Jenkins from your laptop.

Why?

Because there is another network layer:

```text
Browser
  |
Internet
  |
AWS Security Group
  |
EC2
  |
Jenkins
```

---

# Security Group

For initial administration, allow TCP 8080 only from your own public IP where practical.

Conceptually:

```text
Type: Custom TCP
Port: 8080
Source: My IP
```

Then access:

```text
http://<EC2-PUBLIC-IP>:8080
```

---

# Important Networking Lesson

Compare local Jenkins:

```text
localhost:8080
```

with EC2 Jenkins:

```text
EC2-PUBLIC-IP:8080
```

`localhost` always refers to the machine making the connection.

If you type `localhost:8080` on your laptop, you are asking:

> Is something listening on port 8080 on my laptop?

You are **not** asking EC2.

---

# Install Build Tools on EC2

Jenkins can only execute tools available to its build environment.

Verify:

```bash
git --version
node --version
npm --version
```

If the application pipeline needs Node.js, Node.js must be available to the Jenkins execution environment.

Also verify from the Jenkins service user's perspective where necessary.

---

# Configure Pipeline from SCM

Create:

```text
devops-cicd-lab
```

as a Pipeline job.

Use:

```text
Pipeline script from SCM
```

Repository:

```text
your devops-cicd-lab GitHub repository
```

Branch:

```text
*/main
```

Script Path:

```text
Jenkinsfile
```

Run the pipeline.

---

# Part 16 — GitHub Webhooks

# 41. What Is a Webhook?

A webhook is an HTTP notification sent when an event occurs.

Instead of Jenkins repeatedly asking:

> Did anything change?

GitHub tells Jenkins:

> Something changed.

Compare:

```text
POLL SCM

Jenkins ---> GitHub
"Anything new?"
```

with:

```text
WEBHOOK

GitHub ---> Jenkins
"An event happened."
```

---

# Webhook Architecture

```text
git push
   |
   v
GitHub
   |
   | HTTP request
   v
EC2 public network path
   |
   v
AWS Security Group
   |
   v
Jenkins :8080
   |
   v
/github-webhook/
   |
   v
SCM evaluation
   |
   v
Build if relevant
```

---

# Practical 14 — Enable GitHub Webhook Trigger

In Jenkins job configuration, enable:

```text
GitHub hook trigger for GITScm polling
```

Disable Poll SCM for this experiment so you can clearly observe webhook behavior.

---

# Configure the GitHub Webhook

In the GitHub repository:

```text
Settings
→ Webhooks
→ Add webhook
```

Payload URL:

```text
http://<EC2-PUBLIC-IP>:8080/github-webhook/
```

Content type:

```text
application/json
```

Select push events for the basic lab.

For production environments, use appropriately secured HTTPS endpoints and proper webhook/security controls.

---

# Network Access for the Webhook

A webhook is sent from GitHub's infrastructure, not from your laptop.

Therefore this rule:

```text
8080 from My IP
```

does not automatically allow GitHub to reach Jenkins.

This is an important networking lesson.

```text
Your IP
   ≠
GitHub webhook source
```

Use GitHub's current published webhook IP ranges when designing IP-based filtering, and remember that provider ranges can change.

---

# Test a Feature Branch

Create:

```bash
git switch -c test/webhook-trigger
```

Make a change.

Commit:

```bash
git add .
git commit -m "test: verify Jenkins webhook"
```

Push:

```bash
git push -u origin test/webhook-trigger
```

GitHub may successfully send the webhook.

But Jenkins may not build.

Why?

Your Jenkins job is configured for:

```text
*/main
```

This teaches an extremely important distinction:

```text
Webhook delivered successfully
              ≠
A build must run
```

---

# Merge the PR

Create the PR.

Merge into `main`.

Now:

```text
main changed
   |
   v
GitHub webhook
   |
   v
Jenkins receives event
   |
   v
SCM sees relevant branch change
   |
   v
Pipeline starts
```

This is event-driven CI.

---

# HTTP 200 Does Not Mean Build Success

Suppose GitHub webhook delivery shows:

```text
HTTP 200
```

It means the HTTP request was successfully accepted.

It does **not** mean:

```text
pipeline started
tests passed
deployment succeeded
```

Always identify what each signal actually proves.

---

# Part 17 — Jenkins Parameters, Credentials and Artifacts

# 42. Jenkins Parameters

Parameters allow users or automation to supply values to a pipeline.

Add:

```groovy
parameters {
    choice(
        name: 'TARGET_ENV',
        choices: ['staging', 'production'],
        description: 'Select the target environment'
    )
}
```

Access:

```groovy
${params.TARGET_ENV}
```

Example:

```groovy
stage('Deployment Selection') {
    steps {
        echo "Selected deployment environment: ${params.TARGET_ENV}"
    }
}
```

This does not automatically deploy anything.

It demonstrates how deployment behavior can depend on pipeline parameters.

---

# 43. Jenkins Artifacts

Generate coverage:

```groovy
stage('Test') {
    steps {
        sh 'npm test -- --coverage'
    }
}
```

Archive:

```groovy
stage('Archive Coverage') {
    steps {
        archiveArtifacts artifacts: 'coverage/**', fingerprint: true
    }
}
```

Flow:

```text
npm test
   |
   v
coverage/
   |
   v
archiveArtifacts
   |
   v
Preserved Jenkins Artifact
```

---

# 44. Jenkins Credentials

Never hardcode credentials inside:

```text
Jenkinsfile
source code
README
Git URL
shell script
```

Jenkins provides a Credentials system.

Credentials may represent things such as:

```text
tokens
SSH keys
user credentials
cloud credentials
```

A public repository may not require Git authentication for read access.

A private repository does.

---

# Complete Jenkinsfile

At this point the pipeline can look like:

```groovy
pipeline {
    agent any

    parameters {
        choice(
            name: 'TARGET_ENV',
            choices: ['staging', 'production'],
            description: 'Select the target environment'
        )
    }

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

        stage('Deployment Selection') {
            steps {
                echo "Selected deployment environment: ${params.TARGET_ENV}"
            }
        }
    }

    post {

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}
```

---

# Part 18 — Jenkins Troubleshooting

# 45. Pipeline Waiting for Executor

Suppose Jenkins displays:

```text
Started by user
Obtained Jenkinsfile from git
[Pipeline] Start of Pipeline
[Pipeline] node
Still waiting to schedule task
Waiting for next available executor
```

Do not immediately inspect:

```text
npm
Node.js application
tests
security check
```

Why?

None of those stages have executed.

The pipeline is waiting for an execution slot.

---

# Troubleshooting Path

```text
Pipeline waiting
      |
      v
Check executor
      |
      v
Check node
      |
      v
Is node online?
      |
      v
Read offline reason
```

---

# Practical 15 — Investigate Node Resources

Useful Linux commands:

```bash
df -h
```

Check temporary filesystem:

```bash
df -h /tmp
```

Determine filesystem type:

```bash
findmnt /tmp
```

Check memory:

```bash
free -h
```

Check processes:

```bash
ps aux
```

These are Day 1 skills solving a Day 2 problem.

---

# Example Root-Cause Reasoning

Imagine:

```text
/tmp total capacity = 953 MiB

Jenkins required free temporary space = 1 GiB
```

Compare:

```text
953 MiB < 1 GiB
```

Even if `/tmp` were nearly empty, it could never satisfy a 1 GiB free-space threshold.

That is the root cause.

Notice how different this is from saying:

> Jenkins isn't working.

A DevOps engineer should identify **why**.

---

# Correct Troubleshooting Mindset

Bad approach:

```text
Pipeline stuck
   |
restart random services
   |
change random configuration
   |
hope
```

Better:

```text
Observe symptom
      |
Identify layer
      |
Gather evidence
      |
Form hypothesis
      |
Test hypothesis
      |
Identify root cause
      |
Apply targeted fix
      |
Verify
```

---

# 46. Branch Mistake Troubleshooting

Suppose you commit:

```bash
git commit -m "ci: update Jenkins pipeline"
```

and then try:

```bash
git push -u origin feature/new-pipeline
```

but Git reports:

```text
src refspec feature/new-pipeline does not match any
```

Ask:

```bash
git branch
```

and:

```bash
git log --oneline --decorate -5
```

A commit belongs to the branch you were on when you committed it.

Simply typing another branch name in `git push` does not move the commit onto that nonexistent local branch.

You could create the branch at the current commit:

```bash
git switch -c feature/new-pipeline
```

Then:

```bash
git push -u origin feature/new-pipeline
```

---

# Compare Branch History

Before opening a PR:

```bash
git switch main
git pull
```

Then inspect:

```bash
git log --oneline main..feature/new-pipeline
```

This shows commits present on the feature branch but not on local `main`.

This is useful for verifying what a PR should contain.

---

# Part 19 — GitHub Actions vs Jenkins

Both can implement CI/CD.

But their operating models differ.

| Area | GitHub Actions | Jenkins |
|---|---|---|
| Pipeline definition | YAML workflow | Jenkinsfile |
| Execution environment | Runner | Agent/node |
| Hosted option | GitHub-hosted runners | Infrastructure usually managed separately |
| Repository integration | Native GitHub integration | SCM/plugin integration |
| Secrets | GitHub Secrets | Jenkins Credentials |
| Artifacts | Artifact actions | `archiveArtifacts` |
| Job dependencies | `needs` | Pipeline stage/dependency logic |
| Triggers | GitHub events | SCM/webhooks/polling/etc. |
| Infrastructure management | Lower with hosted runners | More control and responsibility |
| Customization | Strong | Very strong |

---

# Which One Should You Learn?

Do not think:

```text
GitHub Actions OR Jenkins
```

Think:

```text
CI/CD principles
        |
        +--> GitHub Actions implementation
        |
        +--> Jenkins implementation
```

Tools change.

The concepts remain.

---

# Local Jenkins vs EC2 Jenkins

```text
LOCAL

Browser
  |
localhost:8080
  |
Jenkins
  |
Local machine resources
```

versus:

```text
EC2

Browser/GitHub
  |
Internet
  |
Security Group
  |
EC2:8080
  |
Jenkins
  |
EC2 resources
```

The Jenkins concepts remain the same.

The infrastructure changes.

---

# Part 20 — Interview Preparation

# 1. What is Git?

**Answer:**

Git is a distributed version-control system used to track changes to files and source code. It allows developers to maintain history, work with branches, merge changes and collaborate safely.

---

# 2. What is the staging area?

**Answer:**

The staging area is the intermediate area between the working directory and a commit. `git add` selects changes for the next commit.

```text
Working Directory
      |
   git add
      |
      v
Staging Area
      |
 git commit
      |
      v
Repository
```

---

# 3. What is the difference between Git and GitHub?

**Answer:**

Git is version-control software. GitHub is a platform that hosts Git repositories and provides collaboration features such as Pull Requests, Actions and repository management.

---

# 4. What is a branch?

**Answer:**

A branch is an independent line of development. It allows developers to work on features or fixes without immediately changing the main branch.

---

# 5. What is a merge conflict?

**Answer:**

A merge conflict occurs when Git cannot automatically determine how competing changes should be combined. The developer must inspect the conflicting changes, choose the correct final content, stage the resolved file and complete the merge.

---

# 6. git fetch vs git pull?

**Answer:**

`git fetch` retrieves information and commits from the remote without automatically integrating them into the current branch. `git pull` retrieves remote changes and then integrates them.

---

# 7. What is CI?

**Answer:**

Continuous Integration is the practice of frequently integrating code changes into a shared repository and automatically validating them using steps such as tests, security checks and builds.

---

# 8. Continuous Delivery vs Continuous Deployment?

**Answer:**

Continuous Delivery keeps validated software ready for release, typically with a deliberate production-release decision. Continuous Deployment automatically releases changes after required checks succeed.

---

# 9. What is a GitHub Actions runner?

**Answer:**

A runner is the execution environment that runs a GitHub Actions job.

---

# 10. What is the difference between a workflow, job and step?

**Answer:**

A workflow is the overall automation definition. A workflow contains jobs, and each job contains steps.

```text
Workflow
└── Job
    ├── Step
    ├── Step
    └── Step
```

---

# 11. uses vs run?

**Answer:**

`uses` invokes an existing GitHub Action, while `run` executes a shell command on the runner.

---

# 12. Why use npm ci in CI?

**Answer:**

`npm ci` performs a clean dependency installation based on the lock file, which helps make CI builds reproducible.

---

# 13. What does needs do?

**Answer:**

`needs` defines dependencies between GitHub Actions jobs. A dependent job waits for required jobs and normally does not continue when required jobs fail.

---

# 14. Does needs transfer files?

**Answer:**

No. `needs` controls job dependency and ordering. Files must be transferred separately, for example through artifacts.

---

# 15. Artifact vs cache?

**Answer:**

An artifact preserves pipeline output such as a test report or build package. A cache stores reusable data mainly to speed up later executions.

---

# 16. What is Jenkins?

**Answer:**

Jenkins is an automation server commonly used to implement CI/CD pipelines.

---

# 17. Controller vs agent?

**Answer:**

The Jenkins controller coordinates jobs, configuration and scheduling. Agents provide execution environments where pipeline work can run.

---

# 18. What is an executor?

**Answer:**

An executor is a work slot on a Jenkins node that allows Jenkins to execute a job.

---

# 19. What is a Jenkinsfile?

**Answer:**

A Jenkinsfile is a text file stored with source code that defines a Jenkins pipeline as code.

---

# 20. What is Pipeline as Code?

**Answer:**

Pipeline as Code means defining CI/CD pipeline behavior in version-controlled files rather than relying only on manually configured UI settings.

---

# 21. Poll SCM vs webhook?

**Answer:**

Poll SCM has Jenkins periodically check the source repository for changes. A webhook is event-driven: the source platform sends Jenkins an HTTP notification when an event occurs.

---

# 22. What does webhook HTTP 200 prove?

**Answer:**

It proves the webhook HTTP request was accepted successfully. It does not by itself prove that a Jenkins build should run or that the pipeline succeeded.

---

# 23. Why might a webhook succeed but Jenkins not build?

Possible reasons include:

- the changed branch is not configured for the job
- SCM sees no relevant change
- job trigger configuration is incorrect
- Jenkins cannot schedule execution
- pipeline conditions prevent execution

Always inspect the evidence rather than assuming the webhook failed.

---

# 24. How would you troubleshoot a CI/CD failure?

**Answer:**

First determine the layer where execution stopped. I inspect the trigger, workflow configuration, runner or agent, checkout, dependency installation, tests, security checks, build and deployment in order. I gather logs and state from the failed layer, form a hypothesis, test it, fix the root cause and verify the pipeline again.

---

# 25. Tell me about a Jenkins problem you solved.

A strong example:

> I encountered a Jenkins pipeline that remained waiting for an executor. Since the application stages had not started, I investigated the Jenkins node rather than debugging the application. Jenkins had marked the node unavailable because of its temporary-space threshold. I checked the filesystems with `df`, inspected `/tmp` with `df -h /tmp` and `findmnt`, and discovered that `/tmp` was a tmpfs whose total capacity was below the configured free-space threshold. After correcting the lab configuration, the node returned online and the pipeline completed successfully. The experience reinforced the importance of identifying the failing layer before attempting a fix.

---

# Final Review Questions

Try answering these without looking at the explanations.

### Git

1. What problem does version control solve?
2. What is Git?
3. What is the difference between Git and GitHub?
4. What is the working directory?
5. What is the staging area?
6. What does `git add` do?
7. What does `git commit` do?
8. What is a commit hash?
9. What is HEAD?
10. What does `git status` show?
11. What is `git diff`?
12. What is `git diff --staged`?
13. What is `.gitignore`?
14. What is a branch?
15. What does `git switch -c` do?
16. What is a merge?
17. What is a fast-forward merge?
18. What is a merge conflict?
19. Why do we `git add` a file after resolving a conflict?
20. What is `origin`?
21. What does `git push -u origin main` mean?
22. What is upstream tracking?
23. What is the difference between fetch and pull?
24. What is a Pull Request?
25. What happens when another commit is pushed to an open PR?

### CI/CD

26. What is Continuous Integration?
27. What is Continuous Delivery?
28. What is Continuous Deployment?
29. Why are automated tests important?
30. What is a security gate?
31. What should happen when a required security job fails?

### GitHub Actions

32. What is a workflow?
33. What is a job?
34. What is a step?
35. What is a runner?
36. Why does a job need checkout?
37. `uses` vs `run`?
38. Why use `npm ci`?
39. What does `needs` do?
40. Can `needs` transfer files?
41. Why can jobs run in parallel?
42. What is an artifact?
43. What is a cache?
44. What is a secret?
45. Why should secrets not be printed?
46. What is `${{ github.ref }}`?
47. Why might a deployment job be skipped?
48. What is the difference between skipped and failed?

### Jenkins

49. What is Jenkins?
50. What is a controller?
51. What is an agent?
52. What is an executor?
53. What does `agent any` mean?
54. What is a Jenkinsfile?
55. Why store a Jenkinsfile in Git?
56. What is Pipeline as Code?
57. Declarative vs Scripted Pipeline?
58. What does `sh 'npm test'` do?
59. What is Pipeline from SCM?
60. What does SCM mean?
61. Why might a private GitHub repository require Jenkins Credentials?
62. What is Poll SCM?
63. What does `H/5 * * * *` accomplish conceptually?
64. What is a webhook?
65. Polling vs webhook?
66. Why does port 8080 matter?
67. What role does an AWS Security Group play?
68. Why might `localhost:8080` work locally but not reach EC2?
69. Why can a webhook return HTTP 200 without starting a build?
70. What is a Jenkins parameter?
71. What is `archiveArtifacts`?
72. GitHub Secrets vs Jenkins Credentials?
73. GitHub Actions runner vs Jenkins agent?
74. What would cause Jenkins to wait for an executor?
75. How would you investigate an offline Jenkins node?

---

# Command Cheat Sheet

## Repository

```bash
git init
git status
git log
git log --oneline
git show HEAD
```

## Staging and Commits

```bash
git add .
git add filename
git commit -m "message"
git diff
git diff --staged
```

## Branches

```bash
git branch
git switch main
git switch -c feature/example
git merge feature/example
```

## Undo

```bash
git restore filename
git restore --staged filename
git revert <commit>
```

## Remotes

```bash
git remote -v
git remote add origin <url>
git push -u origin main
git push
git fetch
git pull
```

## Inspect History

```bash
git log --oneline --graph --decorate --all
git log --oneline main..feature/example
```

## Node.js

```bash
npm install
npm ci
npm test
npm test -- --coverage
npm audit --audit-level=high
node --check src/app.js
```

## Linux Troubleshooting for Jenkins

```bash
systemctl status jenkins
journalctl -u jenkins
ss -tuln | grep :8080
df -h
df -h /tmp
findmnt /tmp
free -h
ps aux
```

## Jenkins Service

```bash
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
sudo systemctl status jenkins
sudo systemctl enable jenkins
```

---

# Final Project Structure

At the end of Day 2, the practical repository should look approximately like:

```text
devops-cicd-lab/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── src/
│   ├── app.js
│   └── server.js
│
├── tests/
│   └── app.test.js
│
├── .gitignore
├── Jenkinsfile
├── package.json
├── package-lock.json
└── README.md
```

---

# Complete Learning Flow

```text
Git Fundamentals
       |
       v
Working Directory
       |
       v
Staging Area
       |
       v
Commits
       |
       v
Branches
       |
       v
Merging
       |
       v
Merge Conflicts
       |
       v
GitHub
       |
       v
Remote Repository
       |
       v
Pull Requests
       |
       v
Node.js Application
       |
       v
Automated Tests
       |
       v
CI/CD Concepts
       |
       v
GitHub Actions
       |
       +---- Test
       |
       +---- Security
       |
       +---- Build
       |
       +---- Artifacts
       |
       +---- Secrets
       |
       +---- Conditional Deployment
       |
       v
Troubleshooting
       |
       v
Jenkins Fundamentals
       |
       v
Local Jenkins
       |
       v
Pipeline as Code
       |
       v
Jenkinsfile
       |
       v
Poll SCM
       |
       v
AWS EC2 Jenkins
       |
       v
Security Groups
       |
       v
GitHub Webhooks
       |
       v
Parameters
       |
       v
Credentials
       |
       v
Artifacts
       |
       v
Troubleshooting
       |
       v
Interview Readiness
```

---

# Day 2 Key Takeaways

Git is not just a collection of commands.

Understand:

```text
Working Directory
        ↓
Staging
        ↓
Commit
        ↓
Branch
        ↓
Remote
        ↓
Pull Request
```

CI/CD is also not just a YAML file.

Understand:

```text
Event
   ↓
Automation
   ↓
Execution Environment
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
Deployment Decision
```

And Jenkins is not simply a web page on port 8080.

Understand:

```text
Controller
    ↓
Node / Agent
    ↓
Executor
    ↓
Workspace
    ↓
Pipeline
    ↓
Stages
    ↓
Steps
```

Finally, troubleshooting is not guessing.

Use:

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
ROOT CAUSE
   ↓
FIX
   ↓
VERIFY
```

That mindset is more important than memorizing commands.

---

# Day 2 Complete

You should now be able to explain the path:

```text
Developer
    ↓
Git
    ↓
GitHub
    ↓
Pull Request
    ↓
CI
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

and implement it using both:

```text
GitHub Actions
```

and:

```text
Jenkins
```

The next step is **Day 3 — Docker**, where the same Node.js application will be packaged into a container.

Instead of only asking:

> "Does the application work on my machine?"

we will begin asking:

> "Can I package the application and its runtime into a reproducible container that can run consistently in different environments?"

That is where Day 3 begins.s