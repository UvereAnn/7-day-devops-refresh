# AWS Lab 26 — Event-driven operations and remediation

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

Manual troubleshooting is essential, but repetitive operations can be automated. AWS **EventBridge** matches events, **Lambda** executes code, **Systems Manager Automation** runs operational playbooks, and **SNS** sends notifications. Good remediation has a clear trigger, narrowly scoped permissions, idempotent actions, observable outcomes, and guardrails to prevent repeated unintended changes.

## Guided practical exercise

**Console route:** EventBridge → Rules; Lambda → Functions; CloudWatch → Alarms. Start with a safe notification-only design: a CloudWatch alarm changes state → EventBridge rule → SNS topic/email subscription. No infrastructure mutation is needed.

```bash
aws sts get-caller-identity
aws events list-rules --query 'Rules[].Name' --output table
aws cloudwatch describe-alarms --query 'MetricAlarms[].{Name:AlarmName,State:StateValue}' --output table
```

**Reasoning exercise:** Suppose an EC2 instance stops responding. Which metric or event triggers the automation? How do you prevent an infinite restart loop? What evidence is logged? Only after answering these should you consider an SSM Automation runbook. SNS subscriptions require recipient confirmation; alarms, logs, and notifications may have costs. Delete test rules, alarms, and subscriptions.

## Troubleshooting and interview practice

- **Question:** What makes a remediation idempotent?
- **Question:** How can an event rule cause a loop?
- **Question:** What should be logged for an automated action?

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
