# AWS Lab 25 — Rolling, blue-green and canary releases

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

A **rolling deployment** updates instances in batches; **blue-green** maintains two environments and switches traffic; **canary** sends a small fraction of traffic to a new version. Deployment strategy is separate from the CI build process. AWS CodeDeploy supports deployment configurations for eligible compute platforms; ECS and EKS have their own rollout capabilities. A health check and rollback plan matter more than a deployment simply reaching 100%.

## Guided practical exercise

**Console route:** CodeDeploy → Applications → Deployment groups (study target-specific options); ECS → Services → Deployments; CloudWatch → Alarms. For a low-cost local simulation, run two application versions on an existing EC2 VM on separate loopback ports and verify each before any cutover:

```bash
curl -fsS http://127.0.0.1:3000/health
curl -fsS http://127.0.0.1:3001/health
```

Only use the second command after deliberately starting a second test version on port 3001. Explain that this is **not** a full blue-green deployment until a proxy or load balancer can switch real traffic and rollback. For an AWS-managed deployment lab, review CodeDeploy/ECS prerequisites, traffic routing, alarms, and pricing before provisioning an ALB.

## Troubleshooting and interview practice

- **Question:** Compare rolling, blue-green, and canary.
- **Question:** How does a health check influence rollback?
- **Question:** What is a Cloud Run revision?

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
