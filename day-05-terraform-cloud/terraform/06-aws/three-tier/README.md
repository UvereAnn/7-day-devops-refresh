# AWS Three-Tier Architecture — Design and Guided Build

This is an **advanced architecture exercise**, not a pre-provisioned working stack. It can incur significant charges (ALB, NAT Gateway, RDS, EC2). Begin by designing and reviewing a plan, not applying it.

## Understand the tiers

1. **Public entry:** Internet-facing Application Load Balancer in public subnets across at least two AZs. HTTPS listener, certificate and target group.
2. **Application:** EC2 Auto Scaling group in private subnets; instances receive traffic from the ALB security group and run our Node.js container.
3. **Data:** Private RDS PostgreSQL instance or cluster; only the application SG can reach TCP/5432. Credentials from a secrets service, not HCL.

```text
Client → HTTPS ALB (public subnets)
                 ↓ target group /health
       EC2 Auto Scaling (private subnets)
                 ↓ database SG
             RDS (private DB subnets)
```

## Terraform build order

- Define VPC and four or more subnets across AZs, route tables and IGW.
- Decide how private app instances access image registries/updates (NAT or appropriate VPC endpoints); estimate network cost.
- Define ALB, target group health check `/health`, listener and SG rules.
- Define launch template, instance role, Auto Scaling group and desired/min/max capacities.
- Define DB subnet group, encrypted storage, backups, deletion protection and private RDS.
- Define logging, monitoring, alarms and safe outputs.
- Split state into manageable components when appropriate and review each plan.

## Practice without a bill

Sketch CIDRs and trust relationships. For every SG, answer **who may initiate traffic to whom, on which port?** Create HCL one component at a time and run `terraform fmt`, `init -backend=false`, `validate`. Do not claim a successful `plan` without a configured provider and credentials. Discuss failure scenarios: ALB unhealthy target, ASG replacement, database inaccessible, NAT outage and leaked secret.

## Interview question

Why is the database private, and why does the app tier need more than one AZ? Explain fault tolerance, lateral movement risk and operational cost.
