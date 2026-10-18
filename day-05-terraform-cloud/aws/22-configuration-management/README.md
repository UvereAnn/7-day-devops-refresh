# AWS Lab 22 — Configuration and fleet management

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

Provisioning an EC2 instance creates a VM; **configuration management** ensures its packages, settings, and services are correct over time. AWS Systems Manager (SSM) offers Session Manager (shell without inbound SSH), Run Command (remote commands), State Manager (desired configuration associations), and Patch Manager. SSM requires a running agent where applicable, network connectivity to Systems Manager endpoints, and a suitable instance IAM role.

## Guided practical exercise

**Console route:** Systems Manager → Fleet Manager → Managed nodes. Reuse a temporary EC2 instance with an attached instance profile granting `AmazonSSMManagedInstanceCore` and an SSM Agent-supported OS. Confirm the instance appears as managed before trying Run Command.

```bash
aws sts get-caller-identity
aws ssm describe-instance-information --query 'InstanceInformationList[].{Id:InstanceId,Status:PingStatus}' --output table
# Only after selecting your own managed instance:
aws ssm start-session --target i-REPLACE_WITH_YOUR_INSTANCE_ID
```

The local AWS CLI Session Manager plugin may be required. Session Manager avoids opening inbound TCP/22, but it still needs IAM authorization and SSM connectivity. In the session, run `uname -a` and `systemctl status nginx` (if installed). Do not execute unreviewed commands across an entire fleet. Stop the lab instance afterward; remove temporary associations and roles only when unused.

## Troubleshooting and interview practice

- **Question:** How is ongoing configuration management different from VM provisioning?
- **Question:** What does an agent need to communicate with cloud management services?
- **Question:** Why avoid fleet-wide commands in a first lab?

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
