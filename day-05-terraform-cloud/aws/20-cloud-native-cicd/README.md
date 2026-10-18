# AWS Lab 20 — Cloud-native CI/CD

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**Continuous integration** compiles/tests code for each change; **continuous delivery** makes a tested release ready; **continuous deployment** automatically releases approved changes. In AWS, **CodeBuild** runs build jobs, **CodePipeline** connects stages, and **CodeDeploy** manages deployments to supported targets. ECR stores container images but does not run a pipeline. For our `devops-cicd-lab`, start with a small buildspec that validates Node.js code before trying deployment.

## Guided practical exercise

**Console route:** CodeBuild → Build projects → Create project. Choose a trusted source (GitHub connection or CodeCommit), a supported managed image, and a service role with minimal permissions. Configure the buildspec in your source repository:

```yaml
# buildspec.yml
version: 0.2
phases:
  install:
    runtime-versions:
      nodejs: 22
  build:
    commands:
      - npm ci
      - npm test --if-present
      - node --check app/index.js
artifacts:
  files:
    - package.json
```

Adjust `app/index.js` to the actual JavaScript entry file and use the Node.js runtime supported by the selected build image. If your project lacks a lockfile, run `npm install` locally and commit `package-lock.json` before using `npm ci`. A successful build should show `SUCCEEDED` and step logs. Next, inspect CodePipeline's **Source → Build → Deploy** stages and explain which stage can fail independently. Build projects, logs, artifacts, and pipelines can incur charges; delete the lab project and any temporary artifacts.

## Troubleshooting and interview practice

- **Question:** What does a build stage verify?
- **Question:** What does an artifact registry store?
- **Question:** What is the difference between delivery and deployment?

**Troubleshooting method:** Identify whether the failure is in identity, permission, region, service configuration, network access, or application behavior. Read the exact error and relevant logs before changing settings. Do not broaden IAM permissions merely to make an error disappear.

## How to study and verify this lab

1. Read the explanation and identify the service's responsibility; do not confuse source hosting, build, deployment, and runtime.
2. Check the active cloud identity, account/project, region, IAM permissions, and billing before running commands.
3. Follow the console path, then run the CLI commands **one at a time** and explain each result.
4. Record your actual output, error messages, and how you resolved them. Never publish tokens, keys, account IDs, private URLs, or secret values.
5. Delete temporary resources and verify cleanup. Cloud charges may continue until deletion; alerts are not hard spending limits.

### Lab journal

- Date and cloud region:
- Identity used (role type only, not identifiers):
- Commands and console steps completed:
- Expected versus actual result:
- Error and diagnosis:
- Resources removed / remaining:
