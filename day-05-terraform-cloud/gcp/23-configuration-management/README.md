# Google Cloud Lab 23 — Configuration and fleet management

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

GCP **VM Manager** helps manage operating-system inventory, patching, and OS policies for Compute Engine VMs. An OS policy describes the desired package/file/service state; it is different from the initial startup script, which usually runs at boot. VM Manager depends on a supported guest OS, OS Config agent, required APIs, and permissions.

## Guided practical exercise

**Console route:** Compute Engine → VM Manager → OS inventory / Patch / OS policies. Create or reuse a small Linux VM and confirm its agent reports inventory. Inspect VM Manager before attempting fleet-wide patching.

```bash
gcloud config get-value project
gcloud services enable osconfig.googleapis.com
gcloud compute instances list
# On your own VM after connecting:
systemctl status google-osconfig-agent --no-pager
```

If the agent is absent or inactive, check the guest image, package status, API enablement, service account permissions, and network connectivity. For a safe first exercise, observe inventory and review available patches rather than scheduling automatic updates. Delete temporary VM resources after recording findings.

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
