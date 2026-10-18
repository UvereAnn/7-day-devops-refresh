# AWS Terraform Project — VPC + EC2 + Existing Node.js App

## Architecture and purpose

Terraform provisions a VPC (`10.20.0.0/16`), public subnet (`10.20.1.0/24`), Internet Gateway, route table, security group and Ubuntu EC2. The EC2 instance runs Docker and our **existing** `devops-cicd-lab` image; Terraform owns the infrastructure, not the app source code.

```text
Ubuntu laptop → Terraform AWS API → VPC → public subnet → EC2
Ubuntu laptop --SSH--> EC2 --Docker--> GHCR image → Node.js /health
Browser --HTTP--> EC2 public IP → published container port
```

## Prerequisites

1. Authorized AWS CLI identity: `aws sts get-caller-identity`.
2. Existing EC2 key pair **in the target region** and its private key kept securely on your Ubuntu laptop.
3. Your public IPv4 address as `/32` for `ssh_cidr`. Never use `0.0.0.0/0` for SSH.
4. Terraform installed and an estimate of EC2/EBS/public IPv4 charges.
5. A strategy to access the **private GHCR** image. Either authenticate on EC2 using a narrowly scoped read-only GitHub token passed securely (never commit or paste it in README), or mirror the image into AWS ECR and give EC2 an instance role with ECR pull permissions. The included Terraform does not yet set up the registry secret/role.

## Read the source files

- `versions.tf` pins Terraform and AWS provider constraints.
- `providers.tf` sets region and default tags.
- `variables.tf` declares `aws_region`, `key_pair_name`, `ssh_cidr`, `instance_type`.
- `main.tf` creates the network, security group and EC2.
- `outputs.tf` shows instance ID, public IP and an example SSH command.

Read the security group in `main.tf`: the app HTTP port is intentionally reachable for a lab; the SSH rule should be restricted to your IP. Review the image, instance type and region before provisioning.

## Run in the project directory

```bash
cd day-05-terraform-cloud/terraform/06-aws/vpc-ec2-app
aws sts get-caller-identity
terraform init
terraform fmt -check
terraform validate
terraform plan -var='key_pair_name=YOUR_KEY_NAME' -var='ssh_cidr=YOUR_PUBLIC_IP/32'
```

Inspect the plan line by line. Only when you are comfortable with cost and access:

```bash
terraform apply -var='key_pair_name=YOUR_KEY_NAME' -var='ssh_cidr=YOUR_PUBLIC_IP/32'
terraform output
```

## SSH and Docker deployment

From **your Ubuntu laptop**:

```bash
chmod 400 ~/Downloads/YOUR_KEY.pem
ssh -i ~/Downloads/YOUR_KEY.pem ubuntu@EC2_PUBLIC_IP
```

Inside EC2, verify Ubuntu and Docker installation; if Docker is not installed, use the Docker official Ubuntu installation guide. Then authenticate to GHCR without putting credentials into shell history or Git. The image is private; a plain `docker pull` will fail without access. Once authenticated:

```bash
docker pull ghcr.io/uvereann/devops-cicd-lab:latest
docker run -d --name devops-cicd-lab -p 3000:3000 ghcr.io/uvereann/devops-cicd-lab:latest
docker ps
docker logs devops-cicd-lab
curl -f http://localhost:3000/health
```

**Verify the actual application port before running** (`package.json`, app source and Dockerfile). If it is not 3000, change both host/container mapping and test URL. To access it publicly, the security group must allow the host port; otherwise test it via SSH tunnel or from inside EC2. The starter Terraform does not guarantee an end-to-end Docker deployment.

## Failure drills

- `InvalidKeyPair.NotFound`: key pair is missing in this AWS region.
- SSH timeout: public IP, subnet route, SG, NACL or local network.
- GHCR `unauthorized`: image private and credentials absent/insufficient.
- Container exits: inspect `docker logs`, environment and command.
- Local health works, browser fails: public ingress SG and published port.

## Cleanup

```bash
terraform destroy -var='key_pair_name=YOUR_KEY_NAME' -var='ssh_cidr=YOUR_PUBLIC_IP/32'
```

Review the destroy plan, confirm EC2/EBS/network resources are gone, and check AWS billing. Do not destroy any resource you intend to keep. Record real results only after execution.
