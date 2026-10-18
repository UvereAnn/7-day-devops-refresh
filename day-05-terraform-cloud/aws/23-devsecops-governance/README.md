# AWS Lab 23 — DevSecOps, policy and governance

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

**DevSecOps** integrates security checks into development and deployment, while **governance** establishes boundaries for cloud accounts and teams. AWS IAM policies grant permissions, AWS Organizations service control policies (SCPs) set maximum permissions in member accounts, AWS Config records/evaluates configurations, Inspector identifies supported workload vulnerabilities, and Security Hub aggregates security findings. A finding is evidence to investigate, not proof that a system was compromised.

## Guided practical exercise

**Console route:** IAM → Policies and Access Analyzer; CloudTrail → Event history; AWS Config / Inspector / Security Hub (check regional availability and charges before enabling).

```bash
aws sts get-caller-identity
aws iam get-account-summary --query 'SummaryMap.{Users:Users,Roles:Roles,Policies:Policies}'
aws cloudtrail lookup-events --max-results 5 --query 'Events[].{Name:EventName,Time:EventTime}' --output table
```

**Practice:** Inspect a role attached to a test EC2 instance. Compare `Action: s3:GetObject` with `Action: s3:*`, and explain why the latter is broader. Review one CloudTrail management event and identify the actor, time, event name, and region without publishing account identifiers. For scanning, inspect ECR image scanning settings and review findings if a test image is available. Do not enable paid security services without checking the cost and opt-in requirements.

## Troubleshooting and interview practice

- **Question:** How do IAM and organizational guardrails differ?
- **Question:** What can audit logs tell you?
- **Question:** How should you prioritize vulnerability findings?

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
