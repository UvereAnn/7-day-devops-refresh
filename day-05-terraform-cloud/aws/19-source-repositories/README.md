# AWS Lab 19 — Cloud source repositories

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**AWS CodeCommit** hosts private Git repositories managed with AWS IAM. Git concepts—commit, branch, merge, push, pull—are the same as GitHub; the difference is repository hosting, authentication, and integration. CodeCommit is separate from CodeBuild (build execution) and CodePipeline (workflow orchestration). A Git repository does not automatically build or deploy an application.

## Guided practical exercise

**Console route:** Developer Tools → CodeCommit → Repositories → Create repository. If CodeCommit is enabled for your account and region, create `devops-codecommit-lab`. Confirm IAM permissions before cloning. For HTTPS access, AWS's Git remote credential helper can use your configured CLI credentials:

```bash
aws sts get-caller-identity
aws codecommit list-repositories
aws codecommit get-repository --repository-name devops-codecommit-lab
# Configure the credential helper in a dedicated lab environment:
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
# Substitute your chosen region:
git clone https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/devops-codecommit-lab
```

Inside the clone, create `README.md`, then `git add`, `git commit`, and `git push`. Use `git remote -v` to verify the destination. **Caution:** global Git helper settings can affect other HTTPS repositories; consider a repository-scoped or conditional Git configuration instead. If you receive `AccessDeniedException`, verify IAM and region, not the Git syntax. Clean up by deleting the practice repository after confirming it contains no needed work.

## Troubleshooting and interview practice

- **Question:** What is the difference between a Git host and a CI service?
- **Question:** What would cause a Git clone to return 403?
- **Question:** When might a cloud-hosted repository be useful?

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
