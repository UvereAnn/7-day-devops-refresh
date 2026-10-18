# AWS Lab 18 — Native infrastructure as code

> **Status:** Guided lesson; not yet executed. This lesson expands Day 5 without using Terraform unless explicitly noted.

## What you will understand

CloudFormation is AWS's declarative infrastructure engine. You describe a desired collection of resources in YAML or JSON, and CloudFormation calculates the operations needed to reach that state. A **stack** is a deployed template; a **change set** previews an update. CloudFormation manages resource dependencies, stack events, and rollback. AWS CDK is a developer-facing way to define cloud infrastructure in TypeScript, Python, and other languages; `cdk synth` generates CloudFormation templates. Neither requires Terraform. A template is *not* an imperative sequence of shell commands: it declares the intended resources.

## Guided practical exercise

**Console route:** CloudFormation → Stacks → Create stack → With new resources → Upload a template file. Review the stack's **Events**, **Resources**, and **Outputs** tabs. Before creating anything, read the generated resource names and pricing implications.

Save this as `bucket.yaml` (replace the bucket name by removing it entirely; CloudFormation will generate one):

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Private S3 learning bucket
Resources:
  LabBucket:
    Type: AWS::S3::Bucket
    Properties:
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true
Outputs:
  BucketName:
    Value: !Ref LabBucket
```

```bash
aws sts get-caller-identity
aws cloudformation validate-template --template-body file://bucket.yaml
aws cloudformation deploy --template-file bucket.yaml --stack-name devops-cfn-lab
aws cloudformation describe-stack-resources --stack-name devops-cfn-lab
aws cloudformation describe-stacks --stack-name devops-cfn-lab --query 'Stacks[0].Outputs'
```

**Why these commands?** `validate-template` checks template structure, `deploy` creates or updates the stack, and the describe commands confirm what AWS actually created. S3 bucket names must be globally unique, so allowing CloudFormation to generate one avoids collisions. An empty bucket can be removed with the stack; remove objects first if you uploaded any.

```bash
aws cloudformation delete-stack --stack-name devops-cfn-lab
aws cloudformation wait stack-delete-complete --stack-name devops-cfn-lab
```

**CDK follow-up:** Install a supported Node.js version, run `npx aws-cdk --version`, create a separate CDK app with `cdk init app --language typescript`, examine `cdk synth`, and only deploy after checking the generated template and cost. CDK deployment uses CloudFormation behind the scenes.

## Troubleshooting and interview practice

- **Question:** How does declarative IaC differ from a shell script?
- **Question:** What is the relationship between CDK and CloudFormation?
- **Question:** Why does Config Connector require a controller?

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
