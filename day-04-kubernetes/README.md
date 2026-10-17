# Day 4 — Kubernetes: Complete Hands-On DevOps Learning Guide

> **7-Day DevOps Refresh — Day 4**
>
> **Topic:** Kubernetes Architecture, Administration, Deployment, Networking, Storage, Security, Troubleshooting, and Production Operations
>
> **Lab Environment:** AWS EC2, Ubuntu 24.04, Docker, KIND, kubectl, Helm, and Kustomize
>
> **Practical Application:** `devops-cicd-lab` — Node.js/Express application developed during Day 2 and containerized during Day 3
>
> **Documentation Repository:** `7-day-devops-refresh`
>
> **Application Repository:** `devops-cicd-lab`

---

# Table of Contents

1. [Introduction to Kubernetes](#1-introduction-to-kubernetes)
2. [Kubernetes Architecture](#2-kubernetes-architecture)
3. [Kubernetes Platforms and Lab Setup](#3-kubernetes-platforms-and-lab-setup)
4. [kubectl Fundamentals and Cluster Administration](#4-kubectl-fundamentals-and-cluster-administration)
5. [Pods and Container Lifecycle](#5-pods-and-container-lifecycle)
6. [Deployments, ReplicaSets, Scaling, and Rollbacks](#6-deployments-replicasets-scaling-and-rollbacks)
7. [Kubernetes Services and Networking](#7-kubernetes-services-and-networking)
8. [Namespaces, Labels, Selectors, and Annotations](#8-namespaces-labels-selectors-and-annotations)
9. [ConfigMaps, Secrets, and Private Registries](#9-configmaps-secrets-and-private-registries)
10. [Kubernetes Storage: PV, PVC, and StorageClass](#10-kubernetes-storage-pv-pvc-and-storageclass)
11. [Health Probes and Resource Management](#11-health-probes-and-resource-management)
12. [Ingress, DNS, and Gateway API](#12-ingress-dns-and-gateway-api)
13. [Kubernetes GUI: Headlamp](#13-kubernetes-gui-headlamp)
14. [Helm and Kustomize](#14-helm-and-kustomize)
15. [Kubernetes Security, RBAC, and NetworkPolicies](#15-kubernetes-security-rbac-and-networkpolicies)
16. [Advanced Kubernetes Workloads and Scheduling](#16-advanced-kubernetes-workloads-and-scheduling)
17. [Kubernetes Troubleshooting and Observability](#17-kubernetes-troubleshooting-and-observability)
18. [KIND, Minikube, MicroK8s, and K3s](#18-kind-minikube-microk8s-and-k3s)
19. [Managed Kubernetes and Enterprise Platforms](#19-managed-kubernetes-and-enterprise-platforms)
20. [Final Project: Deploying devops-cicd-lab](#20-final-project-deploying-devops-cicd-lab)
21. [Kubernetes and CI/CD Integration](#21-kubernetes-and-cicd-integration)
22. [Kubernetes Command Cheat Sheet](#22-kubernetes-command-cheat-sheet)
23. [Troubleshooting Reference](#23-troubleshooting-reference)
24. [Kubernetes Interview Questions and Answers](#24-kubernetes-interview-questions-and-answers)
25. [Lessons Learned and Next Steps](#25-lessons-learned-and-next-steps)

---

# Learning Objectives

By completing Day 4, I aimed to:

- Understand Kubernetes architecture and its major components.
- Explain the relationship between Docker and Kubernetes.
- Create and administer Kubernetes clusters.
- Deploy containerized applications using Pods and Deployments.
- Configure Services and understand cluster networking.
- Manage application configuration with ConfigMaps and Secrets.
- Configure persistent storage.
- Implement health probes and resource management.
- Expose applications using Ingress.
- Use graphical tools to inspect Kubernetes resources.
- Package and customize applications using Helm and Kustomize.
- Apply Kubernetes security best practices.
- Troubleshoot common workload and cluster failures.
- Understand different Kubernetes distributions.
- Compare managed Kubernetes services.
- Deploy the existing `devops-cicd-lab` application on Kubernetes.
- Prepare for practical DevOps and Platform Engineering interviews.

---

# Our Continuous DevOps Project

This seven-day refresh uses practical work to connect individual DevOps technologies.

## Day 2 — Git, GitHub, and CI/CD

We created and worked with:

```text
devops-cicd-lab
```

The project introduced:

- Git version control.
- GitHub remote repositories.
- Branches and merge conflicts.
- Node.js project initialization.
- CI/CD principles.
- GitHub Actions.

## Day 3 — Docker

We containerized the Node.js application and studied:

- Docker images and containers.
- Dockerfiles.
- Multi-stage builds.
- Container networking.
- Docker volumes.
- Image registries.
- Distroless images.
- Container security.
- Vulnerability scanning.

Our existing image reference is:

```text
ghcr.io/uvereann/devops-cicd-lab:latest
```

The Dockerfile uses a Node.js 24 Alpine build stage and a distroless Node.js 24 Debian 13 non-root runtime stage.

## Day 4 — Kubernetes

We extend the same application by deploying it to Kubernetes.

```text
Source Code
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    v
Docker Build and Security Checks
    |
    v
GitHub Container Registry
    |
    v
Kubernetes Deployment
    |
    v
ReplicaSet
    |
    v
Application Pods
    |
    v
Kubernetes Service
    |
    v
Application Access
```

**Important:** Our application repository and documentation repository have different responsibilities.

```text
devops-cicd-lab
    Application source
    Dockerfile
    CI/CD workflow
    Kubernetes deployment manifests

7-day-devops-refresh
    Detailed explanations
    Commands and examples
    Practical exercises
    Troubleshooting
    Interview preparation
```

This README documents both the independent Kubernetes labs and the integration with our application.

---

# 1. Introduction to Kubernetes

## 1.1 What is Kubernetes?

Kubernetes, commonly abbreviated as K8s, is an open-source container orchestration platform.

It automates the deployment, scheduling, scaling, networking, and management of containerized applications.

Kubernetes is designed around a **desired-state model**.

Instead of continuously instructing the system to start, stop, or replace individual containers, we describe the state we want Kubernetes to maintain.

For example:

```text
Desired state: 3 application replicas
Actual state:  2 application replicas

Kubernetes detects the difference.

Kubernetes attempts to create another replica.
```

This continuous process is called **reconciliation**.

## 1.2 Why do we need Kubernetes?

In Day 3, we ran containers using Docker.

Example:

```bash
docker run -d \
  --name devops-cicd-lab \
  -p 3000:3000 \
  ghcr.io/uvereann/devops-cicd-lab:latest
```

This command starts one container, assuming the image is accessible and the application listens on port 3000.

However, production environments introduce additional requirements:

1. Multiple application replicas.
2. Automated recovery from container failures.
3. Scheduling workloads across machines.
4. Rolling updates.
5. Service discovery.
6. Network routing.
7. Configuration management.
8. Persistent storage.
9. Resource allocation.
10. Monitoring and troubleshooting.

Kubernetes provides APIs and controllers for these responsibilities.

## 1.3 Docker versus Kubernetes

| Docker | Kubernetes |
|---|---|
| Builds container images | Deploys workloads using container images |
| Runs containers | Manages Pods containing containers |
| Provides container networking | Provides cluster networking abstractions |
| Provides volumes | Manages persistent storage through Kubernetes APIs |
| Operates primarily at container/host level | Orchestrates workloads across cluster nodes |
| Uses Docker CLI and Dockerfiles | Uses Kubernetes API objects and kubectl |
| Can restart containers | Reconciles workloads to their desired state |

Docker and Kubernetes are complementary.

Kubernetes does not require Docker Engine as its node container runtime.

Modern Kubernetes commonly uses containerd or CRI-O through the Container Runtime Interface (CRI).

## 1.4 Imperative versus declarative management

### Imperative approach

An imperative command tells Kubernetes to perform a specific action.

```bash
kubectl create deployment nginx \
  --image=nginx:1.27-alpine
```

Another example:

```bash
kubectl scale deployment nginx --replicas=3
```

### Declarative approach

A declarative configuration describes the desired state.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
```

Apply:

```bash
kubectl apply -f deployment.yaml
```

Kubernetes compares the declared configuration with the current state and reconciles the differences.

### Why declarative management is preferred

Declarative manifests are easier to:

- Version-control.
- Review.
- Audit.
- Reproduce.
- Integrate with CI/CD.
- Manage through GitOps.
- Reuse across environments.

## 1.5 Kubernetes API objects

A Kubernetes object usually includes:

```yaml
apiVersion:
kind:
metadata:
spec:
```

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
```

### Explanation

**apiVersion**

Identifies the API version used by the resource.

**kind**

Specifies the resource type.

**metadata**

Contains identifying information such as name, namespace, labels, and annotations.

**spec**

Describes the desired configuration.

Many Kubernetes resources also have a `status` field representing observed state.

## 1.6 Common Kubernetes resources

| Resource | Purpose |
|---|---|
| Pod | Runs one or more containers |
| ReplicaSet | Maintains a desired number of Pod replicas |
| Deployment | Manages stateless application rollouts |
| Service | Provides stable network access |
| Namespace | Organizes resources |
| ConfigMap | Stores non-sensitive configuration |
| Secret | Stores sensitive configuration |
| PersistentVolume | Represents storage |
| PersistentVolumeClaim | Requests storage |
| StorageClass | Defines storage provisioning |
| StatefulSet | Manages stable workload identities |
| DaemonSet | Runs workloads on eligible nodes |
| Job | Executes a task to completion |
| CronJob | Runs scheduled Jobs |
| Ingress | Defines HTTP/HTTPS routing |
| NetworkPolicy | Controls permitted network traffic |
| ServiceAccount | Provides workload identity |
| Role/ClusterRole | Defines Kubernetes permissions |
| RoleBinding/ClusterRoleBinding | Assigns Kubernetes permissions |

---

# 2. Kubernetes Architecture

## 2.1 Kubernetes cluster architecture

A Kubernetes cluster contains:

- Control-plane components.
- Worker-node components.

```text
                         KUBERNETES CLUSTER
                                  |
              +-------------------+------------------+
              |                                      |
              v                                      v
      +-------------------+                +-------------------+
      |   CONTROL PLANE   |                |    WORKER NODE    |
      |                   |                |                   |
      | kube-apiserver    |                | kubelet           |
      | etcd              |                | container runtime |
      | kube-scheduler    |                | kube-proxy*       |
      | controller-manager|                |                   |
      +-------------------+                | +---------------+ |
                                           | | Pod           | |
                                           | | Containers    | |
                                           | +---------------+ |
                                           +-------------------+

* Some networking implementations replace kube-proxy.
```

In a single-node KIND lab, the control-plane node can also run application workloads.

## 2.2 Control-plane components

### kube-apiserver

The API server is the main entry point for Kubernetes operations.

When we execute:

```bash
kubectl get pods
```

`kubectl` sends a request to the Kubernetes API server.

The API server handles:

- Authentication.
- Authorization.
- Admission control.
- API validation.
- Resource operations.
- Communication with the cluster-state storage backend.

### etcd

etcd is a distributed key-value store commonly used to store Kubernetes cluster state.

Examples of stored information include:

- Deployment specifications.
- Service definitions.
- Pod specifications.
- ConfigMaps.
- Secrets.
- Cluster metadata.

etcd backup and recovery are important in self-managed production clusters.

### kube-scheduler

The scheduler assigns unscheduled Pods to suitable nodes.

Scheduling decisions consider:

- Available resources.
- CPU and memory requests.
- Node selectors.
- Node affinity.
- Pod affinity and anti-affinity.
- Taints and tolerations.
- Storage topology.
- Scheduling constraints.

### kube-controller-manager

The controller manager runs controllers that continuously reconcile resources.

Examples include:

- Node controller.
- ReplicaSet controller.
- Job controller.
- Namespace controller.

A controller compares desired state against observed state and takes corrective action.

## 2.3 Worker-node components

### kubelet

The kubelet runs on Kubernetes nodes.

It communicates with the API server and ensures assigned Pods are running as specified.

### Container runtime

The container runtime manages containers.

Common examples:

- containerd.
- CRI-O.

### kube-proxy

kube-proxy implements Kubernetes Service networking in many clusters.

It configures network forwarding rules that help Services reach backend Pods.

Some CNI implementations provide alternative Service-routing mechanisms.

## 2.4 What happens when we run kubectl apply?

Consider:

```bash
kubectl apply -f deployment.yaml
```

The simplified sequence is:

```text
kubectl
   |
   v
API Server
   |
   v
Authentication and Authorization
   |
   v
Admission and Validation
   |
   v
Desired State Stored
   |
   v
Deployment Controller
   |
   v
ReplicaSet Created/Updated
   |
   v
Pods Created
   |
   v
Scheduler Assigns Nodes
   |
   v
Kubelet Starts Containers
   |
   v
Container Runtime
```

The scheduler does not start containers directly.

It assigns Pods to nodes.

The kubelet and container runtime perform the node-side work.

## 2.5 Kubernetes reconciliation

Suppose we create:

```yaml
replicas: 3
```

The Deployment controller attempts to maintain three available application replicas.

If one Pod disappears:

```text
Before:
Pod A
Pod B
Pod C

After failure:
Pod A
Pod B

Controller detects the difference.

Replacement Pod D is created.
```

This is called self-healing.

However, Kubernetes cannot guarantee application availability if:

- No suitable nodes exist.
- Required images cannot be pulled.
- Storage cannot attach.
- The application repeatedly crashes.
- The cluster lacks capacity.

Self-healing depends on the surrounding infrastructure being healthy.

---

# 3. Kubernetes Platforms and Lab Setup

## 3.1 Kubernetes installation options

Kubernetes can run in different environments.

### Local and lightweight platforms

- KIND.
- Minikube.
- MicroK8s.
- K3s.

### Managed Kubernetes

- Amazon EKS.
- Google Kubernetes Engine.
- Azure Kubernetes Service.

### Enterprise platforms

- Red Hat OpenShift.
- Rancher-managed Kubernetes environments.

Each platform has different operational characteristics.

## 3.2 Why we used AWS EC2

Our Ubuntu laptop had limited available memory and disk space for running multiple Kubernetes tools.

We therefore used an AWS EC2 instance as our primary Kubernetes lab environment.

### Lab configuration

| Component | Configuration |
|---|---|
| Cloud | AWS |
| Region | us-east-1 |
| Instance name | kubernetes-devops-lab |
| Instance type | t3.large |
| vCPU | 2 |
| Memory | 8 GiB |
| Operating system | Ubuntu 24.04 |
| Storage | 30 GiB gp3 |
| Cluster platform | KIND |
| Cluster name | devops-lab |
| kubectl context | kind-devops-lab |

The instance is a learning environment, not a production Kubernetes deployment.

## 3.3 AWS security configuration

Our security-group approach was:

```text
Inbound:
SSH TCP/22
Source: My public IP

No public Kubernetes API, dashboard, or application ports
unless explicitly needed and securely configured.
```

Important security practices:

- Restrict SSH access.
- Protect private SSH keys.
- Do not expose Kubernetes dashboards publicly.
- Avoid opening Kubernetes API port 6443 to the internet.
- Use port-forwarding and SSH tunnels for local testing.
- Never commit cloud credentials or kubeconfig secrets.

## 3.4 AWS cost management

AWS resources may incur charges for:

- EC2 compute.
- EBS storage.
- Public IPv4 addresses.
- Data transfer.
- Other attached resources.

We configured a budget alert as part of cost awareness.

A budget alert is **not** a guaranteed spending limit.

Stopping EC2 generally stops instance compute charges, but some other resources can continue to incur costs.

## 3.5 Connect to EC2

Example local SSH command:

```bash
chmod 400 ~/.ssh/kubernetes-devops-key.pem
```

```bash
ssh -i ~/.ssh/kubernetes-devops-key.pem \
  ubuntu@YOUR_EC2_PUBLIC_IP
```

Alternatively, use EC2 Instance Connect where supported.

Do not publish private keys or credentials.

## 3.6 Install Docker

Docker was installed on Ubuntu using the official Docker package repository.

After installation, verify:

```bash
docker --version
```

```bash
sudo systemctl status docker
```

Test:

```bash
docker run --rm hello-world
```

For our lab, the `ubuntu` user was added to the Docker group.

```bash
sudo usermod -aG docker ubuntu
```

A new login session is normally required for group membership changes to take effect.

**Security:** Membership in the Docker group provides privileges comparable to root access on the host.

## 3.7 Install kubectl

Install a kubectl version compatible with the Kubernetes cluster version.

Verify:

```bash
kubectl version --client
```

```bash
kubectl version --client -o yaml
```

kubectl is the primary CLI used to communicate with Kubernetes.

## 3.8 Install KIND

KIND stands for **Kubernetes IN Docker**.

It creates Kubernetes nodes as Docker containers.

Verify the installed binary:

```bash
kind version
```

Create our cluster:

```bash
kind create cluster --name devops-lab
```

Check available clusters:

```bash
kind get clusters
```

Expected:

```text
devops-lab
```

Check nodes:

```bash
kubectl get nodes
```

Expected structure:

```text
NAME                       STATUS   ROLES
devops-lab-control-plane   Ready    control-plane
```

Check context:

```bash
kubectl config current-context
```

Expected:

```text
kind-devops-lab
```

## 3.9 How KIND works

```text
AWS EC2
   |
   v
Ubuntu Linux
   |
   v
Docker Engine
   |
   v
KIND Node Container
   |
   +-- Kubernetes Control Plane
   |
   +-- kubelet
   |
   +-- containerd
   |
   +-- Application Pods
```

KIND is suitable for:

- Development.
- Kubernetes learning.
- Automated testing.
- CI integration.
- Temporary clusters.

It is not a substitute for a properly designed production Kubernetes platform.

## 3.10 Inspect KIND

```bash
kind get clusters
```

```bash
docker ps
```

```bash
kubectl cluster-info
```

```bash
kubectl get nodes -o wide
```

```bash
kubectl get pods -A
```

## 3.11 Lab directory structure

Our learning workspace follows this general structure:

```text
~/kubernetes-labs/
└── day-04/
    ├── pods/
    ├── deployments/
    ├── services/
    ├── namespaces/
    ├── configmaps-secrets/
    ├── storage/
    ├── probes-resources/
    ├── ingress/
    ├── headlamp/
    ├── helm-kustomize/
    ├── security/
    ├── advanced-workloads/
    ├── troubleshooting/
    ├── cluster-comparison/
    └── final-project/
```

These directories organize independent Kubernetes exercises.

Our actual application manifests will also be organized in the separate `devops-cicd-lab` repository.

---

# 4. kubectl Fundamentals and Cluster Administration

## 4.1 What is kubectl?

kubectl is the Kubernetes command-line tool.

It communicates with the Kubernetes API server to manage resources.

General syntax:

```bash
kubectl [command] [resource] [name] [flags]
```

Examples:

```bash
kubectl get pods
```

```bash
kubectl describe pod nginx-pod
```

```bash
kubectl delete pod nginx-pod
```

## 4.2 Inspect cluster resources

Get nodes:

```bash
kubectl get nodes
```

Get Pods:

```bash
kubectl get pods
```

Get Deployments:

```bash
kubectl get deployments
```

Get Services:

```bash
kubectl get services
```

Get namespaces:

```bash
kubectl get namespaces
```

Get resources across namespaces:

```bash
kubectl get pods -A
```

`-A` means all namespaces.

## 4.3 Output formats

Wide output:

```bash
kubectl get pods -o wide
```

YAML:

```bash
kubectl get pod nginx-pod -o yaml
```

JSON:

```bash
kubectl get pod nginx-pod -o json
```

Custom columns:

```bash
kubectl get pods \
  -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
```

## 4.4 Describe resources

```bash
kubectl describe pod nginx-pod
```

This provides:

- Resource configuration.
- Current status.
- Container information.
- Scheduling details.
- Recent events.

`describe` is especially useful when troubleshooting.

## 4.5 Application logs

```bash
kubectl logs nginx-pod
```

Follow logs:

```bash
kubectl logs -f nginx-pod
```

Logs from a previous terminated container instance:

```bash
kubectl logs nginx-pod --previous
```

Logs from a Deployment:

```bash
kubectl logs deployment/nginx-deployment
```

## 4.6 Execute commands in containers

```bash
kubectl exec -it nginx-pod -- /bin/sh
```

This works only if the container image contains the requested shell.

Distroless images often do not include a shell.

For distroless workloads, use logs, events, metrics, and supported debugging techniques rather than assuming `/bin/sh` is available.

## 4.7 Apply and delete manifests

Apply:

```bash
kubectl apply -f deployment.yaml
```

Delete:

```bash
kubectl delete -f deployment.yaml
```

Apply all manifests in a directory:

```bash
kubectl apply -f manifests/
```

Delete all resources described by those manifests:

```bash
kubectl delete -f manifests/
```

Always verify the active cluster context before destructive commands.

## 4.8 Kubernetes contexts

A kubeconfig context associates:

- Cluster.
- User or authentication identity.
- Optional default namespace.

List contexts:

```bash
kubectl config get-contexts
```

Current context:

```bash
kubectl config current-context
```

Switch context:

```bash
kubectl config use-context kind-devops-lab
```

Set default namespace:

```bash
kubectl config set-context \
  --current \
  --namespace=development
```

Restore default:

```bash
kubectl config set-context \
  --current \
  --namespace=default
```

### Why contexts matter

An incorrect context can result in deploying or deleting resources in the wrong cluster.

Before modifying production resources, verify:

```bash
kubectl config current-context
```

```bash
kubectl get nodes
```

## 4.9 API discovery

List supported resource types:

```bash
kubectl api-resources
```

Explain a resource:

```bash
kubectl explain deployment
```

Explain a field:

```bash
kubectl explain deployment.spec
```

Explain nested fields:

```bash
kubectl explain deployment.spec.strategy
```

These commands are useful when learning YAML specifications.

## 4.10 Namespace-aware commands

```bash
kubectl get pods -n development
```

```bash
kubectl get deployments -n staging
```

```bash
kubectl get services -n production
```

```bash
kubectl get pods -A
```

---

# 5. Pods and Container Lifecycle

## 5.1 What is a Pod?

A Pod is the smallest deployable workload unit in Kubernetes.

A Pod contains one or more containers that share:

- Network namespace.
- Pod IP address.
- Localhost networking.
- Configured volumes.
- Pod lifecycle.

A Pod is not the same as a container.

A Pod provides the execution environment for containers.

## 5.2 Pod architecture

```text
Kubernetes Node
    |
    v
+-------------------------+
| Pod                     |
|                         |
| Shared Network          |
| Shared Volumes          |
|                         |
| Container A             |
| Container B (optional)  |
+-------------------------+
```

Containers within the same Pod can communicate using `localhost`.

## 5.3 Practical: Create an Nginx Pod

Create the directory:

```bash
mkdir -p ~/kubernetes-labs/day-04/pods
```

```bash
cd ~/kubernetes-labs/day-04/pods
```

Create:

```bash
nano nginx-pod.yaml
```

Manifest:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
      ports:
        - containerPort: 80
```

Apply:

```bash
kubectl apply -f nginx-pod.yaml
```

Verify:

```bash
kubectl get pods
```

Expected:

```text
NAME        READY   STATUS    RESTARTS
nginx-pod   1/1     Running   0
```

The exact restart count and age depend on the cluster state.

## 5.4 Inspect the Pod

```bash
kubectl describe pod nginx-pod
```

```bash
kubectl get pod nginx-pod -o wide
```

```bash
kubectl logs nginx-pod
```

## 5.5 Execute commands

```bash
kubectl exec -it nginx-pod -- /bin/sh
```

Inside:

```sh
hostname
```

```sh
ls /usr/share/nginx/html
```

Exit:

```sh
exit
```

## 5.6 Port-forwarding

```bash
kubectl port-forward pod/nginx-pod 8080:80
```

From another terminal on the EC2 host:

```bash
curl -I http://127.0.0.1:8080
```

Expected successful response:

```text
HTTP/1.1 200 OK
```

Stop port-forwarding with `Ctrl+C`.

## 5.7 Pod lifecycle

Common Pod phases:

| Phase | Meaning |
|---|---|
| Pending | Accepted but not fully scheduled or initialized |
| Running | Bound to a node and at least one container is running or starting/restarting |
| Succeeded | All containers terminated successfully and will not restart |
| Failed | All containers terminated and at least one failed |
| Unknown | Pod status cannot be determined |

Other displayed statuses include:

- `ContainerCreating`.
- `CrashLoopBackOff`.
- `ImagePullBackOff`.
- `ErrImagePull`.
- `CreateContainerConfigError`.
- `Terminating`.

These are commonly container states or kubectl display reasons, not all official Pod phases.

## 5.8 Pod restart policies

Available values:

```yaml
restartPolicy: Always
```

```yaml
restartPolicy: OnFailure
```

```yaml
restartPolicy: Never
```

For a Deployment, the Pod restart policy must be `Always`.

## 5.9 Why we don't usually deploy standalone Pods

Standalone Pods are useful for learning and debugging.

However, a standalone Pod is not automatically recreated by a Deployment controller if it is deleted.

Production applications are generally managed through higher-level workload controllers such as Deployments or StatefulSets.

---

# 6. Deployments, ReplicaSets, Scaling, and Rollbacks

## 6.1 What is a Deployment?

A Deployment manages stateless application workloads.

It supports:

- Desired replica counts.
- Rolling updates.
- Rollbacks.
- Self-healing.
- Declarative application updates.

## 6.2 Deployment architecture

```text
Deployment
    |
    v
ReplicaSet
    |
    +------ Pod 1
    |
    +------ Pod 2
    |
    +------ Pod 3
```

A Deployment manages ReplicaSets.

ReplicaSets maintain the desired number of Pods.

## 6.3 Practical: Create a Deployment

```bash
mkdir -p ~/kubernetes-labs/day-04/deployments
```

```bash
cd ~/kubernetes-labs/day-04/deployments
```

Create:

```bash
nano nginx-deployment.yaml
```

Manifest:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-deployment
spec:
  replicas: 3

  selector:
    matchLabels:
      app: nginx-deployment

  template:
    metadata:
      labels:
        app: nginx-deployment

    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          ports:
            - containerPort: 80
```

Apply:

```bash
kubectl apply -f nginx-deployment.yaml
```

Verify:

```bash
kubectl get deployments
```

```bash
kubectl get replicasets
```

```bash
kubectl get pods -o wide
```

Expected Deployment readiness after successful rollout:

```text
READY
3/3
```

## 6.4 Understanding the manifest

### replicas

```yaml
replicas: 3
```

Requests three Pods.

### selector

```yaml
selector:
  matchLabels:
    app: nginx-deployment
```

Identifies Pods managed by the Deployment.

### template

```yaml
template:
```

Defines the Pod template used to create replicas.

### containers

```yaml
containers:
  - name: nginx
    image: nginx:1.27-alpine
```

Defines the application container.

## 6.5 Scaling

Scale to five replicas:

```bash
kubectl scale deployment/nginx-deployment \
  --replicas=5
```

Verify:

```bash
kubectl get deployment nginx-deployment
```

```bash
kubectl get pods -l app=nginx-deployment
```

Scale back:

```bash
kubectl scale deployment/nginx-deployment \
  --replicas=3
```

## 6.6 Self-healing experiment

List Pods:

```bash
kubectl get pods -l app=nginx-deployment
```

Delete one Pod:

```bash
kubectl delete pod POD_NAME
```

Check again:

```bash
kubectl get pods -l app=nginx-deployment
```

The ReplicaSet should attempt to create a replacement Pod.

### What we learned

Kubernetes controllers continuously reconcile desired state.

Deleting an individual Pod does not change the Deployment's desired replica count.

## 6.7 Rolling updates

Update the container image:

```bash
kubectl set image deployment/nginx-deployment \
  nginx=nginx:1.28-alpine
```

This is an example of a version update. Use a tag confirmed to exist and be compatible with the workload.

Watch rollout:

```bash
kubectl rollout status deployment/nginx-deployment
```

Inspect history:

```bash
kubectl rollout history deployment/nginx-deployment
```

## 6.8 Rolling-update strategy

Example:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### maxSurge

Maximum additional Pods allowed above the desired replica count during rollout.

### maxUnavailable

Maximum number of unavailable Pods allowed during rollout.

With `maxUnavailable: 0`, Kubernetes aims to preserve the desired number of available replicas during an update.

Actual availability still depends on readiness, capacity, and cluster health.

## 6.9 Rollback

```bash
kubectl rollout undo deployment/nginx-deployment
```

Check:

```bash
kubectl rollout status deployment/nginx-deployment
```

Inspect:

```bash
kubectl rollout history deployment/nginx-deployment
```

## 6.10 Deployment troubleshooting

If rollout fails:

```bash
kubectl describe deployment nginx-deployment
```

```bash
kubectl get pods
```

```bash
kubectl describe pod POD_NAME
```

```bash
kubectl logs POD_NAME
```

Common causes:

- Invalid image tag.
- Image registry authentication failure.
- Application crash.
- Readiness probe failure.
- Insufficient resources.
- Invalid configuration.

---

# 7. Kubernetes Services and Networking

## 7.1 Why Services exist

Pod IP addresses are not guaranteed to remain stable.

When Pods are replaced, their IP addresses may change.

A Service provides a stable network identity for accessing selected Pods.

```text
Client
   |
   v
Kubernetes Service
   |
   +------ Pod A
   |
   +------ Pod B
   |
   +------ Pod C
```

## 7.2 Types of Services

### ClusterIP

Exposes the Service inside the cluster.

```yaml
type: ClusterIP
```

This is the default Service type.

### NodePort

Exposes the Service through a port on cluster nodes.

```yaml
type: NodePort
```

NodePort is not automatically a secure public exposure mechanism.

Firewall rules and network reachability still matter.

### LoadBalancer

Requests integration with an external load-balancing implementation.

```yaml
type: LoadBalancer
```

On cloud platforms, this often provisions or configures a cloud load balancer.

On local clusters, an additional implementation may be required.

### ExternalName

Maps a Service name to an external DNS name.

```yaml
type: ExternalName
```

It does not create a traditional Pod-backed Service.

## 7.3 Practical: ClusterIP Service

Create:

```bash
mkdir -p ~/kubernetes-labs/day-04/services
```

```bash
cd ~/kubernetes-labs/day-04/services
```

Create `nginx-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: ClusterIP
  selector:
    app: nginx-deployment
  ports:
    - name: http
      port: 80
      targetPort: 80
```

Apply:

```bash
kubectl apply -f nginx-service.yaml
```

Verify:

```bash
kubectl get services
```

```bash
kubectl describe service nginx-service
```

## 7.4 How Service selectors work

The Service selector is:

```yaml
selector:
  app: nginx-deployment
```

The Deployment Pod template contains:

```yaml
labels:
  app: nginx-deployment
```

These labels must match.

If they do not match, the Service may have no backend endpoints.

## 7.5 EndpointSlices

EndpointSlices represent network endpoints associated with Services.

Inspect:

```bash
kubectl get endpointslices
```

For a specific Service:

```bash
kubectl get endpointslices \
  -l kubernetes.io/service-name=nginx-service
```

A Service with no ready endpoints cannot route normal application traffic to ready backend Pods.

## 7.6 Test Service connectivity

```bash
kubectl port-forward service/nginx-service 8080:80
```

From another terminal:

```bash
curl -I http://127.0.0.1:8080
```

## 7.7 Kubernetes DNS

Kubernetes commonly provides cluster DNS through CoreDNS.

A Service DNS name typically follows:

```text
service-name.namespace.svc.cluster.local
```

Example:

```text
nginx-service.default.svc.cluster.local
```

Within the same namespace, a Pod can often use:

```text
nginx-service
```

## 7.8 DNS troubleshooting

Inspect CoreDNS:

```bash
kubectl get pods -n kube-system
```

Inspect the DNS Service:

```bash
kubectl get service kube-dns -n kube-system
```

Run a temporary DNS test Pod:

```bash
kubectl run dns-test \
  --image=busybox:1.36 \
  --restart=Never \
  --command -- sleep 3600
```

Execute:

```bash
kubectl exec dns-test -- \
  nslookup nginx-service.default.svc.cluster.local
```

Cleanup:

```bash
kubectl delete pod dns-test
```

## 7.9 Kubernetes networking model

The Kubernetes networking model generally expects:

- Pods to have network addresses.
- Pods to communicate across nodes without application-level NAT assumptions.
- Nodes to communicate with Pods.
- Services to provide stable virtual endpoints.

The Container Network Interface (CNI) implementation provides much of the underlying Pod networking.

Examples include:

- Calico.
- Cilium.
- Flannel.

NetworkPolicy enforcement depends on the cluster networking implementation.

---

# 8. Namespaces, Labels, Selectors, and Annotations

## 8.1 What is a Namespace?

A Namespace provides a logical boundary for organizing namespaced Kubernetes resources.

Namespaces are useful for:

- Development environments.
- Staging environments.
- Production environments.
- Teams.
- Applications.
- Access control.
- Resource quotas.

Namespaces alone do not guarantee network or security isolation.

## 8.2 Create namespaces

```bash
kubectl create namespace development
```

```bash
kubectl create namespace staging
```

```bash
kubectl create namespace production
```

Verify:

```bash
kubectl get namespaces
```

## 8.3 Namespace manifest

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: development
```

Apply:

```bash
kubectl apply -f namespace.yaml
```

## 8.4 Deploy into a namespace

```bash
kubectl create deployment dev-nginx \
  --image=nginx:1.27-alpine \
  --replicas=2 \
  -n development
```

For staging:

```bash
kubectl create deployment dev-nginx \
  --image=nginx:1.27-alpine \
  --replicas=1 \
  -n staging
```

Verify:

```bash
kubectl get deployments -n development
```

```bash
kubectl get deployments -n staging
```

These Deployments can share a name because they exist in different namespaces.

## 8.5 Labels

Labels are key-value metadata used to organize and select resources.

Example:

```yaml
metadata:
  labels:
    app: nginx
    environment: development
    team: platform
```

List resources by label:

```bash
kubectl get pods -l app=nginx
```

Multiple selectors:

```bash
kubectl get pods \
  -l app=nginx,environment=development
```

## 8.6 Add labels

```bash
kubectl label pod nginx-pod environment=development
```

Overwrite:

```bash
kubectl label pod nginx-pod \
  environment=staging \
  --overwrite
```

## 8.7 Annotations

Annotations store descriptive metadata not generally used for resource selection.

Example:

```yaml
metadata:
  annotations:
    description: "Kubernetes learning workload"
    owner: "platform-team"
```

Add an annotation:

```bash
kubectl annotate pod nginx-pod \
  description="Learning Kubernetes"
```

## 8.8 Labels versus annotations

| Labels | Annotations |
|---|---|
| Used for selection and organization | Used for additional metadata |
| Used by Services and controllers | Used by tools and integrations |
| Generally concise | Can contain richer metadata |
| Queryable through label selectors | Not selected using label selectors |

---

# 9. ConfigMaps, Secrets, and Private Registries

## 9.1 Why externalize configuration?

Application configuration should not always be hardcoded into container images.

Different environments may need different values.

For example:

```text
Development:
APP_ENV=development

Production:
APP_ENV=production
```

Kubernetes provides ConfigMaps and Secrets for configuration management.

## 9.2 ConfigMaps

A ConfigMap stores non-sensitive configuration data.

Example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: development
data:
  APP_ENV: "development"
  APP_PORT: "3000"
```

Apply:

```bash
kubectl apply -f configmap.yaml
```

Inspect:

```bash
kubectl get configmap app-config -n development
```

```bash
kubectl describe configmap app-config -n development
```

## 9.3 Use a ConfigMap as environment variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-demo
  namespace: development
spec:
  containers:
    - name: app
      image: busybox:1.36
      command:
        - sh
        - -c
        - "echo APP_ENV=$APP_ENV; sleep 3600"
      envFrom:
        - configMapRef:
            name: app-config
```

Apply:

```bash
kubectl apply -f config-demo.yaml
```

Check:

```bash
kubectl logs config-demo -n development
```

Expected:

```text
APP_ENV=development
```

## 9.4 ConfigMap as files

ConfigMaps can also be mounted as volumes.

Example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: file-config
  namespace: development
data:
  app.conf: |
    APP_ENV=development
    LOG_LEVEL=info
```

Mounting the ConfigMap makes the file available inside the container.

## 9.5 Secrets

Secrets store sensitive information such as:

- Passwords.
- API credentials.
- Registry authentication.
- Tokens.
- Certificates.

However, Kubernetes Secrets are not automatically equivalent to a dedicated encrypted secret-management system.

Base64 encoding is not encryption.

Production clusters should configure appropriate encryption at rest, RBAC, access auditing, and secret-management integrations.

## 9.6 Secret example

A non-sensitive demonstration:

```bash
kubectl create secret generic demo-secret \
  --from-literal=DEMO_VALUE=example-only \
  -n development
```

Verify the object exists:

```bash
kubectl get secret demo-secret -n development
```

Delete:

```bash
kubectl delete secret demo-secret -n development
```

Do not commit real Secret values to GitHub.

## 9.7 Private GHCR images

Our application image is:

```text
ghcr.io/uvereann/devops-cicd-lab:latest
```

The package has been treated as private during our labs.

Kubernetes therefore needs authorized registry access unless the package visibility or access model changes.

## 9.8 imagePullSecrets

A Docker registry Secret allows Kubernetes to authenticate when pulling a private image.

Create a suitable GitHub token with package read access.

For a classic personal access token, `read:packages` is commonly required. Package access restrictions or organization authorization may also apply.

Avoid storing the token in shell history.

A secure workflow is to create the registry Secret using an approved credential-management process.

For a temporary learning environment, an interactive approach is:

```bash
read -rsp "GHCR token: " GHCR_TOKEN
echo
```

```bash
kubectl create secret docker-registry ghcr-secret \
  --namespace=devops-app \
  --docker-server=ghcr.io \
  --docker-username=uvereann \
  --docker-password="$GHCR_TOKEN"
```

```bash
unset GHCR_TOKEN
```

This avoids literal token values in shell history, but command-line arguments may still be temporarily visible to privileged processes.

Use an approved external secret-management or credential-delivery workflow for production.

Verify without displaying credentials:

```bash
kubectl get secret ghcr-secret -n devops-app
```

Expected type:

```text
kubernetes.io/dockerconfigjson
```

## 9.9 Reference imagePullSecrets in a Pod

```yaml
spec:
  imagePullSecrets:
    - name: ghcr-secret
```

The Secret must be in the same namespace as the Pod.

## 9.10 Troubleshooting ImagePullBackOff

Inspect:

```bash
kubectl get pods -n devops-app
```

```bash
kubectl describe pod POD_NAME -n devops-app
```

Possible causes:

- Incorrect image path.
- Missing image tag.
- Invalid token.
- Insufficient package permissions.
- Missing imagePullSecret.
- Secret in the wrong namespace.
- Registry connectivity failure.

Never print or share registry credentials while troubleshooting.

---

# 10. Kubernetes Storage: PV, PVC, and StorageClass

## 10.1 Why persistent storage matters

Containers and Pods are replaceable.

Data stored only in a container's writable layer is not a reliable persistent-storage solution.

Applications may require storage for:

- Databases.
- Uploaded files.
- Application-generated data.
- Persistent configuration.
- Stateful services.

Kubernetes separates storage requests from underlying storage implementations.

## 10.2 Kubernetes storage concepts

### Volume

A volume provides storage to containers in a Pod.

### PersistentVolume (PV)

A PersistentVolume represents storage available to the cluster.

### PersistentVolumeClaim (PVC)

A PersistentVolumeClaim requests storage.

### StorageClass

A StorageClass describes how storage should be provisioned.

## 10.3 Storage relationship

```text
Application Pod
      |
      v
PersistentVolumeClaim
      |
      v
PersistentVolume
      |
      v
Underlying Storage
```

## 10.4 Our KIND storage lab

Our cluster node was:

```text
devops-lab-control-plane
```

Because KIND nodes run as Docker containers, a path inside the KIND node is not automatically the same as a path on the EC2 host.

We created storage inside the KIND node:

```bash
docker exec devops-lab-control-plane \
  mkdir -p /mnt/k8s-storage
```

## 10.5 PersistentVolume manifest

Create `pv.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: devops-pv
spec:
  capacity:
    storage: 1Gi

  accessModes:
    - ReadWriteOnce

  persistentVolumeReclaimPolicy: Retain

  storageClassName: manual

  local:
    path: /mnt/k8s-storage

  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - devops-lab-control-plane
```

### Explanation

`capacity` describes the storage capacity.

`accessModes` describes supported access patterns.

`Retain` means Kubernetes does not automatically delete the underlying storage when the PV is released.

`storageClassName` identifies the storage class associated with the volume.

`local.path` identifies the path inside the Kubernetes node.

`nodeAffinity` ensures workloads using this local PV are scheduled on the appropriate node.

**Important:** Retain does not protect against deletion of the underlying KIND Docker node container.

## 10.6 PersistentVolumeClaim

Create `pvc.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: devops-pvc
  namespace: development
spec:
  accessModes:
    - ReadWriteOnce

  storageClassName: manual

  resources:
    requests:
      storage: 1Gi
```

Apply:

```bash
kubectl apply -f pv.yaml
```

```bash
kubectl apply -f pvc.yaml
```

Verify:

```bash
kubectl get pv
```

```bash
kubectl get pvc -n development
```

Expected after successful binding:

```text
STATUS
Bound
```

## 10.7 Pod using the PVC

Create `persistent-demo.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: persistent-demo
  namespace: development
spec:
  containers:
    - name: storage-demo
      image: busybox:1.36
      command:
        - sh
        - -c
        - sleep 3600

      volumeMounts:
        - name: app-storage
          mountPath: /data

  volumes:
    - name: app-storage
      persistentVolumeClaim:
        claimName: devops-pvc
```

Apply:

```bash
kubectl apply -f persistent-demo.yaml
```

Verify:

```bash
kubectl get pod persistent-demo -n development
```

Write data:

```bash
kubectl exec persistent-demo -n development -- \
  sh -c 'echo "Kubernetes persistent storage lab" > /data/message.txt'
```

Read data:

```bash
kubectl exec persistent-demo -n development -- \
  cat /data/message.txt
```

Expected:

```text
Kubernetes persistent storage lab
```

## 10.8 Persistence testing

A useful exercise is to recreate a Pod using the same PVC and confirm that the stored file remains available.

However, the data persists only while the underlying storage remains intact.

For our KIND lab, deleting the cluster removes its node container and can destroy node-local data.

## 10.9 Dynamic provisioning

A StorageClass can allow PVCs to trigger automatic storage provisioning.

Example on a managed cloud platform:

```text
PVC Created
    |
    v
StorageClass Selected
    |
    v
CSI Driver
    |
    v
Cloud Volume Provisioned
    |
    v
PV Bound to PVC
```

CSI stands for Container Storage Interface.

Examples include:

- AWS EBS CSI driver.
- GKE Persistent Disk CSI driver.
- Azure Disk CSI driver.

## 10.10 Storage troubleshooting

PVC Pending:

```bash
kubectl describe pvc devops-pvc -n development
```

Check StorageClasses:

```bash
kubectl get storageclass
```

Check PVs:

```bash
kubectl get pv
```

Common causes:

- No matching PV.
- Wrong StorageClass.
- Unsupported access mode.
- Insufficient storage.
- Node affinity mismatch.
- Provisioner failure.
- Delayed binding until Pod scheduling.

---

# 11. Health Probes and Resource Management

## 11.1 Why health checks matter

A container can be running while the application inside it is unhealthy.

For example:

- The process exists but cannot serve requests.
- The application is still initializing.
- A dependency is unavailable.
- The application is deadlocked.

Kubernetes provides health probes to help manage these situations.

## 11.2 Startup probe

A startup probe checks whether the application has started.

It is useful for applications with slow initialization.

While a startup probe is configured and has not succeeded, Kubernetes delays liveness and readiness probe evaluation.

## 11.3 Readiness probe

A readiness probe determines whether a container is ready to receive normal Service traffic.

If readiness fails, the Pod can remain running but is removed from ready Service endpoints.

Readiness failure does not automatically restart the container.

## 11.4 Liveness probe

A liveness probe determines whether a container should be restarted.

If the liveness probe repeatedly fails beyond its threshold, kubelet restarts the container according to the Pod's restart policy.

## 11.5 Probe comparison

| Probe | Main purpose | Failure effect |
|---|---|---|
| Startup | Detect successful startup | Can restart container after threshold |
| Readiness | Determine traffic readiness | Removes Pod from ready endpoints |
| Liveness | Detect unhealthy container | Restarts container |

## 11.6 Practical health-check Deployment

Create `nginx-health.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-health
  namespace: development
spec:
  replicas: 2

  selector:
    matchLabels:
      app: nginx-health

  template:
    metadata:
      labels:
        app: nginx-health

    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine

          ports:
            - name: http
              containerPort: 80

          startupProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
            failureThreshold: 12

          readinessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
            failureThreshold: 3

          livenessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 10
            failureThreshold: 3

          resources:
            requests:
              cpu: "100m"
              memory: "64Mi"

            limits:
              cpu: "500m"
              memory: "128Mi"
```

Apply:

```bash
kubectl apply -f nginx-health.yaml
```

Verify:

```bash
kubectl get deployment nginx-health -n development
```

```bash
kubectl describe deployment nginx-health -n development
```

## 11.7 Resource requests

Requests influence scheduling.

Example:

```yaml
requests:
  cpu: "100m"
  memory: "64Mi"
```

### CPU

`100m` means 100 millicores, or 0.1 CPU core.

### Memory

`64Mi` means 64 mebibytes.

The scheduler uses requests when evaluating node capacity.

## 11.8 Resource limits

Example:

```yaml
limits:
  cpu: "500m"
  memory: "128Mi"
```

CPU limits can throttle CPU usage.

Memory limits can result in an OOM kill if a container exceeds its effective memory limit.

## 11.9 Kubernetes QoS classes

Kubernetes assigns Pods to QoS classes.

### Guaranteed

CPU and memory requests equal limits for every container, with the required values set.

### Burstable

The Pod has some resource requests or limits but does not qualify as Guaranteed.

### BestEffort

No CPU or memory requests or limits are configured for its containers.

QoS affects resource-pressure handling, including eviction behavior.

## 11.10 Troubleshooting OOMKilled

Inspect:

```bash
kubectl describe pod POD_NAME -n development
```

Look for:

```text
Reason: OOMKilled
```

Check previous logs:

```bash
kubectl logs POD_NAME -n development --previous
```

Investigate:

- Application memory usage.
- Memory leaks.
- Resource limits.
- Workload demand.
- Container startup behavior.

Do not automatically increase memory limits without investigating the underlying cause.

---

# 12. Ingress, DNS, and Gateway API

## 12.1 Why Ingress exists

A Kubernetes Service provides networking access to workloads.

Ingress provides HTTP and HTTPS routing rules for accessing Services.

An Ingress resource requires a compatible Ingress controller.

## 12.2 Ingress architecture

```text
Client
   |
   v
DNS
   |
   v
Ingress Controller
   |
   v
Ingress Routing Rules
   |
   v
Kubernetes Service
   |
   v
Application Pods
```

## 12.3 Ingress versus Ingress controller

### Ingress

A Kubernetes API resource containing HTTP/HTTPS routing rules.

### Ingress controller

Software that implements those rules.

Examples:

- Traefik.
- NGINX-based controllers.
- Cloud-provider controllers.

Creating an Ingress object alone does not guarantee traffic routing.

## 12.4 Our Traefik lab

We installed Traefik through Helm.

Namespace:

```text
ingress-system
```

Helm release:

```text
traefik
```

Check:

```bash
helm list -n ingress-system
```

```bash
kubectl get pods -n ingress-system
```

```bash
kubectl get services -n ingress-system
```

## 12.5 Ingress manifest

Create `nginx-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: default
spec:
  ingressClassName: traefik

  rules:
    - host: nginx.local.test
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
```

Apply:

```bash
kubectl apply -f nginx-ingress.yaml
```

Verify:

```bash
kubectl get ingress
```

```bash
kubectl describe ingress nginx-ingress
```

## 12.6 Test Ingress

Forward Traefik locally:

```bash
kubectl port-forward \
  -n ingress-system \
  service/traefik \
  8080:80
```

From another EC2 terminal:

```bash
curl -H "Host: nginx.local.test" \
  http://127.0.0.1:8080/
```

The `Host` header allows Traefik to match the configured hostname.

This approach avoids exposing the Ingress controller publicly.

## 12.7 DNS and TLS

In production, public DNS commonly points to a load balancer or other public entry point.

HTTPS requires suitable TLS certificates and configuration.

Common production tools and services include:

- cert-manager.
- Let's Encrypt.
- Cloud DNS services.
- Managed load balancers.
- Cloud certificate managers.

TLS termination location depends on architecture.

## 12.8 Gateway API

Gateway API provides more expressive networking resources than traditional Ingress for many use cases.

Common resources include:

- GatewayClass.
- Gateway.
- HTTPRoute.

Example relationship:

```text
GatewayClass
     |
     v
Gateway
     |
     v
HTTPRoute
     |
     v
Service
     |
     v
Pods
```

Gateway API requires a compatible controller implementation.

It is not automatically functional just because its CRDs exist.

---

# 13. Kubernetes GUI: Headlamp

## 13.1 What is Headlamp?

Headlamp is a graphical interface for Kubernetes.

It can help operators and developers inspect:

- Nodes.
- Pods.
- Deployments.
- Services.
- Namespaces.
- Events.
- Resource details.

A GUI complements kubectl but does not replace understanding Kubernetes APIs and troubleshooting commands.

## 13.2 Why we explored Headlamp

During our labs, we wanted a graphical way to inspect Kubernetes without exposing the cluster dashboard to the internet.

Our approach used:

- Headlamp deployed in Kubernetes.
- ClusterIP Service.
- Kubernetes port-forwarding.
- SSH tunneling.
- Restricted Kubernetes access.

## 13.3 Headlamp deployment

Our lab used Helm to deploy Headlamp in:

```text
headlamp
```

Check:

```bash
helm list -n headlamp
```

```bash
kubectl get pods -n headlamp
```

```bash
kubectl get services -n headlamp
```

## 13.4 Secure local access

On EC2:

```bash
kubectl port-forward \
  -n headlamp \
  service/headlamp \
  8081:80
```

From the laptop:

```bash
ssh -i ~/.ssh/kubernetes-devops-key.pem \
  -L 8081:127.0.0.1:8081 \
  ubuntu@YOUR_EC2_PUBLIC_IP
```

Open locally:

```text
http://localhost:8081
```

This creates a tunnel between the laptop and EC2.

It avoids opening a public dashboard port in the AWS security group.

## 13.5 Read-only ServiceAccount

We created a ServiceAccount for restricted viewing.

Example:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: headlamp-viewer
  namespace: headlamp
```

A ClusterRoleBinding can associate this ServiceAccount with Kubernetes' built-in `view` ClusterRole.

Example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: headlamp-viewer-binding
subjects:
  - kind: ServiceAccount
    name: headlamp-viewer
    namespace: headlamp
roleRef:
  kind: ClusterRole
  name: view
  apiGroup: rbac.authorization.k8s.io
```

The built-in `view` role provides read-oriented access to many Kubernetes resources, but not unrestricted access to Secrets.

## 13.6 Short-lived authentication token

```bash
kubectl create token headlamp-viewer \
  -n headlamp \
  --duration=1h
```

Treat the returned token as a credential.

Do not publish it in screenshots, GitHub, logs, or documentation.

## 13.7 Headlamp versus Rancher

| Headlamp | Rancher |
|---|---|
| Kubernetes graphical interface | Kubernetes management platform |
| Useful for resource inspection | Useful for managing Kubernetes fleets |
| Can access multiple clusters | Strong multi-cluster management focus |
| Lightweight learning tool | Broader platform-management capabilities |

---

# 14. Helm and Kustomize

## 14.1 Why package management matters

Kubernetes applications often require several resources:

- Deployment.
- Service.
- ConfigMap.
- Secret references.
- Ingress.
- ServiceAccount.
- Autoscaling configuration.

Managing many individual YAML files can become difficult.

Helm and Kustomize help organize and customize Kubernetes configurations.

## 14.2 What is Helm?

Helm is a package manager for Kubernetes.

It packages related Kubernetes resources into charts.

A Helm chart can contain:

- Templates.
- Default values.
- Metadata.
- Dependencies.

## 14.3 Helm chart structure

```text
devops-web/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    └── service.yaml
```

## 14.4 Chart.yaml

```yaml
apiVersion: v2
name: devops-web
description: Helm chart for a Kubernetes web application
type: application
version: 0.1.0
appVersion: "1.0.0"
```

### Explanation

`version` represents the chart version.

`appVersion` represents the application version described by the chart.

They are separate concepts.

## 14.5 values.yaml

```yaml
replicaCount: 2

image:
  repository: nginx
  tag: "1.27-alpine"

service:
  type: ClusterIP
  port: 80
```

## 14.6 Deployment template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}

  selector:
    matchLabels:
      app: {{ .Release.Name }}

  template:
    metadata:
      labels:
        app: {{ .Release.Name }}

    spec:
      containers:
        - name: nginx
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 80
```

Helm substitutes values when rendering the template.

## 14.7 Service template

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type }}

  selector:
    app: {{ .Release.Name }}

  ports:
    - port: {{ .Values.service.port }}
      targetPort: 80
```

## 14.8 Helm commands

Check Helm:

```bash
helm version
```

Validate chart structure:

```bash
helm lint ./devops-web
```

Render manifests:

```bash
helm template web-dev ./devops-web
```

Install into development:

```bash
helm install web-dev ./devops-web \
  -n development
```

Install into staging:

```bash
helm install web-staging ./devops-web \
  -n staging \
  --set replicaCount=1
```

List releases:

```bash
helm list -A
```

## 14.9 Helm upgrades

```bash
helm upgrade web-dev ./devops-web \
  -n development \
  --set replicaCount=3
```

Inspect history:

```bash
helm history web-dev -n development
```

Rollback:

```bash
helm rollback web-dev REVISION_NUMBER \
  -n development
```

## 14.10 Helm troubleshooting

Inspect rendered manifests:

```bash
helm template web-dev ./devops-web
```

Check release:

```bash
helm status web-dev -n development
```

Inspect Kubernetes resources:

```bash
kubectl get all -n development
```

Helm rendering problems and Kubernetes runtime problems are different.

A chart may render successfully while its Pods fail to start.

## 14.11 What is Kustomize?

Kustomize customizes Kubernetes manifests without requiring a template language.

It supports:

- Bases.
- Overlays.
- Patches.
- Name prefixes.
- Labels.
- Image overrides.
- Environment-specific configuration.

kubectl includes Kustomize functionality through:

```bash
kubectl apply -k
```

## 14.12 Kustomize directory structure

```text
kustomize-web/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── development/
    │   └── kustomization.yaml
    └── staging/
        └── kustomization.yaml
```

## 14.13 Base kustomization

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
```

## 14.14 Development overlay

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: development

namePrefix: dev-

resources:
  - ../../base
```

## 14.15 Staging overlay

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: staging

namePrefix: staging-

resources:
  - ../../base
```

## 14.16 Render overlays

```bash
kubectl kustomize overlays/development
```

```bash
kubectl kustomize overlays/staging
```

Apply:

```bash
kubectl apply -k overlays/development
```

```bash
kubectl apply -k overlays/staging
```

## 14.17 Helm versus Kustomize

| Helm | Kustomize |
|---|---|
| Uses charts | Uses bases and overlays |
| Supports templating | Uses YAML transformations and patches |
| Supports chart dependencies | Focuses on manifest customization |
| Manages releases | Applies rendered Kubernetes resources |
| Supports release history and rollback | Relies on Kubernetes/Git workflows for version history |

Both tools are valuable.

Helm is useful for packaging and distributing applications.

Kustomize is useful for maintaining environment-specific variations of Kubernetes manifests.

---

# 15. Kubernetes Security, RBAC, and NetworkPolicies

## 15.1 Kubernetes security layers

Kubernetes security involves multiple layers.

```text
Cloud IAM
    |
    v
Cluster Authentication
    |
    v
Kubernetes Authorization
    |
    v
Admission Controls
    |
    v
Pod Security
    |
    v
Container Security
    |
    v
Network and Storage Security
```

## 15.2 Authentication versus authorization

Authentication answers:

```text
Who are you?
```

Authorization answers:

```text
What are you allowed to do?
```

Kubernetes commonly uses RBAC for authorization.

## 15.3 RBAC resources

- Role.
- ClusterRole.
- RoleBinding.
- ClusterRoleBinding.

### Role

Defines permissions within a namespace.

### ClusterRole

Defines permissions that can apply cluster-wide or be reused within namespaces.

### RoleBinding

Assigns a Role or ClusterRole within a namespace.

### ClusterRoleBinding

Assigns a ClusterRole at cluster scope.

## 15.4 ServiceAccounts

A ServiceAccount provides an identity for workloads running in Kubernetes.

It is not the same as a human user account.

## 15.5 Practical RBAC example

Create ServiceAccount:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: devops-viewer
  namespace: development
```

Create Role:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: development
rules:
  - apiGroups: [""]
    resources:
      - pods
    verbs:
      - get
      - list
      - watch
```

Create RoleBinding:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: development

subjects:
  - kind: ServiceAccount
    name: devops-viewer
    namespace: development

roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

## 15.6 Verify permissions

```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:development:devops-viewer \
  -n development
```

Expected:

```text
yes
```

Check whether it can delete Pods:

```bash
kubectl auth can-i delete pods \
  --as=system:serviceaccount:development:devops-viewer \
  -n development
```

Expected:

```text
no
```

These checks assume the Role and RoleBinding have been applied.

## 15.7 Principle of least privilege

Give identities only the permissions they need.

Avoid granting `cluster-admin` for routine application access.

Separate:

- Read-only access.
- Application deployment access.
- Cluster administration.
- Secret access.
- Infrastructure administration.

## 15.8 Pod securityContext

Example:

```yaml
securityContext:
  runAsNonRoot: true
  seccompProfile:
    type: RuntimeDefault
```

Container-level configuration:

```yaml
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

These settings reduce unnecessary container privileges.

Compatibility depends on the application and image.

## 15.9 Pod Security Admission

Kubernetes supports Pod Security Admission policies.

Common levels:

- Privileged.
- Baseline.
- Restricted.

Example namespace label:

```bash
kubectl label namespace security-lab \
  pod-security.kubernetes.io/enforce=restricted
```

This assumes the namespace exists.

Restricted policies may reject workloads that lack required security settings.

## 15.10 NetworkPolicies

NetworkPolicies define allowed network traffic for selected Pods.

Example:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-nginx-ingress
  namespace: development
spec:
  podSelector:
    matchLabels:
      app: nginx-health

  policyTypes:
    - Ingress

  ingress:
    - from:
        - podSelector:
            matchLabels:
              access: allowed
      ports:
        - protocol: TCP
          port: 80
```

This policy allows selected traffic to matching Pods.

**Important:** NetworkPolicy enforcement requires a compatible networking implementation.

Our default KIND networking setup may not enforce NetworkPolicies.

Creating a NetworkPolicy object does not prove traffic is being restricted.

## 15.11 Production security checklist

- Use least-privilege RBAC.
- Restrict API server access.
- Use secure workload identities.
- Avoid long-lived static credentials.
- Scan container images.
- Run containers as non-root where possible.
- Drop unnecessary capabilities.
- Use seccomp profiles.
- Configure network isolation.
- Encrypt sensitive data appropriately.
- Configure audit logging.
- Patch cluster components.
- Control admission policies.
- Protect CI/CD credentials.
- Use trusted image registries.

---

# 16. Advanced Workloads and Scheduling

## 16.1 StatefulSets

StatefulSets manage workloads that require stable identities.

Common use cases:

- Databases.
- Distributed stateful applications.
- Systems requiring stable network identities.

StatefulSets provide stable Pod names and ordered identity management.

They do not automatically guarantee database replication, backup, or high availability.

## 16.2 StatefulSet architecture

```text
StatefulSet: stateful-nginx

stateful-nginx-0
stateful-nginx-1
stateful-nginx-2
```

The ordinal identities remain stable across Pod recreation.

## 16.3 Headless Service

A headless Service commonly supports stable network identities for StatefulSets.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: stateful-nginx
  namespace: development
spec:
  clusterIP: None

  selector:
    app: stateful-nginx

  ports:
    - port: 80
      name: web
```

## 16.4 StatefulSet manifest

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: stateful-nginx
  namespace: development
spec:
  serviceName: stateful-nginx
  replicas: 3

  selector:
    matchLabels:
      app: stateful-nginx

  template:
    metadata:
      labels:
        app: stateful-nginx

    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          ports:
            - containerPort: 80
              name: web
```

Apply the headless Service and StatefulSet.

Verify:

```bash
kubectl get statefulsets -n development
```

```bash
kubectl get pods -n development
```

## 16.5 DaemonSets

A DaemonSet ensures a Pod runs on each eligible node.

Common use cases:

- Log collectors.
- Node monitoring agents.
- Networking agents.
- Security agents.

Example:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor-demo
  namespace: development
spec:
  selector:
    matchLabels:
      app: node-monitor-demo

  template:
    metadata:
      labels:
        app: node-monitor-demo

    spec:
      containers:
        - name: monitor
          image: busybox:1.36
          command:
            - sh
            - -c
            - "while true; do echo node-monitor-running; sleep 30; done"
```

Verify:

```bash
kubectl get daemonsets -n development
```

On our single-node KIND cluster, expect one eligible node unless scheduling restrictions apply.

## 16.6 Jobs

Jobs execute tasks until successful completion criteria are met.

Example:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: report-job
  namespace: development
spec:
  template:
    spec:
      restartPolicy: Never

      containers:
        - name: report
          image: busybox:1.36
          command:
            - sh
            - -c
            - "echo Generating report; sleep 5; echo Report completed"
```

Apply:

```bash
kubectl apply -f report-job.yaml
```

Verify:

```bash
kubectl get jobs -n development
```

Logs:

```bash
kubectl logs job/report-job -n development
```

## 16.7 CronJobs

CronJobs schedule Jobs.

Example:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: scheduled-report
  namespace: development
spec:
  schedule: "*/5 * * * *"

  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never

          containers:
            - name: report
              image: busybox:1.36
              command:
                - sh
                - -c
                - "echo Scheduled report executed"
```

This schedule runs approximately every five minutes according to the CronJob controller's scheduling behavior.

Verify:

```bash
kubectl get cronjobs -n development
```

```bash
kubectl get jobs -n development
```

## 16.8 Node selectors

Node selectors constrain scheduling to nodes with matching labels.

Label a node:

```bash
kubectl label node devops-lab-control-plane \
  workload=training
```

Pod configuration:

```yaml
nodeSelector:
  workload: training
```

A Pod with this selector can schedule only on nodes carrying that label.

Remove the label:

```bash
kubectl label node devops-lab-control-plane \
  workload-
```

## 16.9 Node affinity

Node affinity provides more expressive scheduling rules.

Example:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: workload
              operator: In
              values:
                - training
```

## 16.10 Taints and tolerations

Taints repel Pods unless those Pods have matching tolerations.

Example taint:

```bash
kubectl taint nodes NODE_NAME \
  dedicated=platform:NoSchedule
```

A matching toleration:

```yaml
tolerations:
  - key: dedicated
    operator: Equal
    value: platform
    effect: NoSchedule
```

Remove the taint:

```bash
kubectl taint nodes NODE_NAME \
  dedicated=platform:NoSchedule-
```

## 16.11 Scheduling troubleshooting

If a Pod remains Pending:

```bash
kubectl describe pod POD_NAME -n development
```

Check:

- Node selectors.
- Node affinity.
- Taints and tolerations.
- CPU and memory requests.
- PVC constraints.
- Node readiness.

---

# 17. Kubernetes Troubleshooting and Observability

## 17.1 Kubernetes troubleshooting methodology

A useful troubleshooting sequence is:

```text
Identify symptom
      |
      v
Check resource status
      |
      v
Describe resource
      |
      v
Inspect events
      |
      v
Inspect logs
      |
      v
Check configuration
      |
      v
Identify root cause
      |
      v
Apply correction
      |
      v
Verify recovery
```

Avoid changing multiple unrelated settings before understanding the failure.

## 17.2 Create troubleshooting namespace

```bash
kubectl create namespace troubleshooting
```

Create directory:

```bash
mkdir -p ~/kubernetes-labs/day-04/troubleshooting
```

```bash
cd ~/kubernetes-labs/day-04/troubleshooting
```

## 17.3 Scenario 1: CrashLoopBackOff

Create `crashloop-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: crashloop-demo
  namespace: troubleshooting
spec:
  containers:
    - name: demo
      image: busybox:1.36
      command:
        - sh
        - -c
        - "echo Application failed; exit 1"
```

Apply:

```bash
kubectl apply -f crashloop-pod.yaml
```

Check:

```bash
kubectl get pods -n troubleshooting
```

Expected after repeated failures:

```text
CrashLoopBackOff
```

Inspect:

```bash
kubectl describe pod crashloop-demo -n troubleshooting
```

```bash
kubectl logs crashloop-demo -n troubleshooting
```

```bash
kubectl logs crashloop-demo \
  -n troubleshooting \
  --previous
```

### Root cause

The process exits with status code 1.

### Fix

Change the command to a long-running process:

```yaml
command:
  - sh
  - -c
  - "echo Application started; sleep 3600"
```

Delete and recreate the standalone Pod:

```bash
kubectl delete -f crashloop-pod.yaml
```

```bash
kubectl apply -f crashloop-pod.yaml
```

Verify:

```bash
kubectl get pod crashloop-demo -n troubleshooting
```

## 17.4 Scenario 2: ImagePullBackOff

Create `imagepull-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: imagepull-demo
  namespace: troubleshooting
spec:
  containers:
    - name: nginx
      image: nginx:tag-that-does-not-exist-12345
```

Apply:

```bash
kubectl apply -f imagepull-pod.yaml
```

Inspect:

```bash
kubectl describe pod imagepull-demo -n troubleshooting
```

### Root cause

The requested image tag does not exist.

### Fix

Change:

```yaml
image: nginx:1.27-alpine
```

Recreate the standalone Pod:

```bash
kubectl delete -f imagepull-pod.yaml
```

```bash
kubectl apply -f imagepull-pod.yaml
```

## 17.5 Scenario 3: CreateContainerConfigError

Create `configerror-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configerror-demo
  namespace: troubleshooting
spec:
  containers:
    - name: demo
      image: busybox:1.36
      command:
        - sh
        - -c
        - "echo $APP_ENV; sleep 3600"

      env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: missing-config
              key: APP_ENV
```

Apply:

```bash
kubectl apply -f configerror-pod.yaml
```

Inspect:

```bash
kubectl describe pod configerror-demo -n troubleshooting
```

### Root cause

The referenced ConfigMap does not exist.

### Fix

```bash
kubectl create configmap missing-config \
  --from-literal=APP_ENV=development \
  -n troubleshooting
```

The existing Pod can recover once the required configuration becomes available.

Verify:

```bash
kubectl get pod configerror-demo -n troubleshooting
```

## 17.6 Scenario 4: Pending Pod

Create `pending-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pending-demo
  namespace: troubleshooting
spec:
  nodeSelector:
    environment: impossible-value

  containers:
    - name: nginx
      image: nginx:1.27-alpine
```

Apply:

```bash
kubectl apply -f pending-pod.yaml
```

Inspect:

```bash
kubectl describe pod pending-demo -n troubleshooting
```

### Root cause

No node matches the required selector.

### Fix

Remove the invalid node selector.

Recreate the standalone Pod:

```bash
kubectl delete -f pending-pod.yaml
```

```bash
kubectl apply -f pending-pod.yaml
```

## 17.7 Scenario 5: Readiness probe failure

Create `readiness-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: readiness-demo
  namespace: troubleshooting
spec:
  replicas: 2

  selector:
    matchLabels:
      app: readiness-demo

  template:
    metadata:
      labels:
        app: readiness-demo

    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine

          ports:
            - containerPort: 80

          readinessProbe:
            httpGet:
              path: /incorrect-health-path
              port: 80
            periodSeconds: 5
```

Apply:

```bash
kubectl apply -f readiness-deployment.yaml
```

Inspect:

```bash
kubectl get pods -n troubleshooting
```

```bash
kubectl describe pod POD_NAME -n troubleshooting
```

### Root cause

The readiness probe checks an endpoint that returns an unsuccessful response.

### Fix

Change:

```yaml
path: /
```

Apply:

```bash
kubectl apply -f readiness-deployment.yaml
```

Verify rollout:

```bash
kubectl rollout status deployment/readiness-demo \
  -n troubleshooting
```

## 17.8 Scenario 6: Broken Service selector

Create `broken-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: broken-service
  namespace: troubleshooting
spec:
  selector:
    app: wrong-label

  ports:
    - port: 80
      targetPort: 80
```

Apply:

```bash
kubectl apply -f broken-service.yaml
```

Inspect:

```bash
kubectl describe service broken-service \
  -n troubleshooting
```

Check EndpointSlices:

```bash
kubectl get endpointslices \
  -n troubleshooting \
  -l kubernetes.io/service-name=broken-service
```

### Root cause

The Service selector does not match the Deployment's Pod labels.

### Fix

```bash
kubectl patch service broken-service \
  -n troubleshooting \
  -p '{"spec":{"selector":{"app":"readiness-demo"}}}'
```

Verify:

```bash
kubectl describe service broken-service \
  -n troubleshooting
```

Test:

```bash
kubectl port-forward \
  -n troubleshooting \
  service/broken-service \
  8083:80
```

In another terminal:

```bash
curl -I http://127.0.0.1:8083
```

## 17.9 Scenario 7: DNS troubleshooting

Create a debugging Pod:

```bash
kubectl run dns-debug \
  --image=busybox:1.36 \
  --restart=Never \
  -n troubleshooting \
  --command -- sleep 3600
```

Test DNS:

```bash
kubectl exec dns-debug -n troubleshooting -- \
  nslookup broken-service
```

Test full DNS name:

```bash
kubectl exec dns-debug -n troubleshooting -- \
  nslookup broken-service.troubleshooting.svc.cluster.local
```

Inspect DNS configuration:

```bash
kubectl exec dns-debug -n troubleshooting -- \
  cat /etc/resolv.conf
```

Check CoreDNS:

```bash
kubectl get pods -n kube-system
```

## 17.10 Scenario 8: Pending PVC

Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pending-pvc
  namespace: troubleshooting
spec:
  storageClassName: nonexistent-class

  accessModes:
    - ReadWriteOnce

  resources:
    requests:
      storage: 5Gi
```

Apply:

```bash
kubectl apply -f pending-pvc.yaml
```

Inspect:

```bash
kubectl describe pvc pending-pvc \
  -n troubleshooting
```

### Root cause

No matching StorageClass/provisioner or suitable PV exists.

Delete the exercise PVC:

```bash
kubectl delete pvc pending-pvc \
  -n troubleshooting
```

## 17.11 Metrics Server

Metrics Server provides resource metrics used by tools such as:

```bash
kubectl top nodes
```

```bash
kubectl top pods -A
```

Check availability:

```bash
kubectl get deployment metrics-server \
  -n kube-system
```

If Metrics Server was installed in the lab, inspect:

```bash
kubectl logs deployment/metrics-server \
  -n kube-system
```

In some local KIND environments, kubelet certificate verification issues may require special lab configuration.

Disabling kubelet TLS verification is not a production security recommendation.

## 17.12 Debugging distroless containers

Our Node.js application uses a distroless runtime image.

Distroless images typically omit:

- Bash.
- Common shell utilities.
- Package managers.
- Interactive debugging tools.

Therefore, this may fail:

```bash
kubectl exec -it POD_NAME -- /bin/sh
```

Instead, investigate:

```bash
kubectl logs POD_NAME
```

```bash
kubectl describe pod POD_NAME
```

```bash
kubectl get events
```

Where supported and authorized, ephemeral debugging containers can provide additional diagnostic tools.

## 17.13 Observability pillars

### Logs

Application and infrastructure events.

### Metrics

Numerical measurements such as CPU, memory, request rates, and error counts.

### Traces

Request execution paths across services.

Common observability technologies include:

- Prometheus.
- Grafana.
- Loki.
- OpenTelemetry.
- CloudWatch.
- Google Cloud Monitoring.
- Azure Monitor.

## 17.14 Cleanup

After completing the troubleshooting exercises:

```bash
kubectl delete namespace troubleshooting
```

This removes the temporary troubleshooting resources in that namespace.

---

# 18. KIND, Minikube, MicroK8s, and K3s

## 18.1 Why different Kubernetes distributions exist

Kubernetes has many components.

Different distributions simplify installation and operations for different use cases.

## 18.2 Platform comparison

| Platform | Primary focus | Typical environment |
|---|---|---|
| KIND | Kubernetes testing | Docker-based local or CI environment |
| Minikube | Local development | Developer machine or lab VM |
| MicroK8s | Packaged Kubernetes | Ubuntu, edge, development |
| K3s | Lightweight Kubernetes | Edge, small servers, production |
| EKS | Managed Kubernetes | AWS |
| GKE | Managed Kubernetes | Google Cloud |
| AKS | Managed Kubernetes | Azure |

## 18.3 KIND

Create:

```bash
kind create cluster --name devops-lab
```

List:

```bash
kind get clusters
```

Delete:

```bash
kind delete cluster --name devops-lab
```

**Warning:** Deleting the cluster destroys its Kubernetes state and node-local data.

Do not run this command against our active learning cluster unless the data has been preserved and deletion is intentional.

## 18.4 Minikube

Minikube simplifies local Kubernetes development.

Install the appropriate binary for the host architecture.

Example Docker-driver startup:

```bash
minikube start \
  --driver=docker \
  --cpus=2 \
  --memory=4096
```

Verify:

```bash
minikube status
```

```bash
kubectl get nodes
```

List add-ons:

```bash
minikube addons list
```

Enable Metrics Server:

```bash
minikube addons enable metrics-server
```

Stop:

```bash
minikube stop
```

## 18.5 MicroK8s

MicroK8s is maintained by Canonical.

Install on supported Ubuntu systems:

```bash
sudo snap install microk8s --classic
```

Check status:

```bash
sudo microk8s status --wait-ready
```

Check nodes:

```bash
sudo microk8s kubectl get nodes
```

Enable DNS:

```bash
sudo microk8s enable dns
```

Enable hostpath storage:

```bash
sudo microk8s enable hostpath-storage
```

Stop:

```bash
sudo microk8s stop
```

## 18.6 K3s

K3s is a lightweight Kubernetes distribution.

The official project provides an installation script and binaries.

Before using a remote installer, inspect its source and understand the changes it will make to the host.

Example download:

```bash
curl -fsSL https://get.k3s.io -o install-k3s.sh
```

Inspect:

```bash
less install-k3s.sh
```

After validating the official installer:

```bash
sudo sh install-k3s.sh
```

Verify:

```bash
sudo k3s kubectl get nodes
```

Check system service:

```bash
sudo systemctl status k3s
```

Stop:

```bash
sudo systemctl stop k3s
```

## 18.7 Resource management on EC2

Our instance has limited resources.

Running multiple Kubernetes distributions simultaneously can create:

- Memory pressure.
- CPU contention.
- Disk exhaustion.
- Port conflicts.
- Networking conflicts.

We therefore planned sequential distribution experiments.

Before switching platforms:

```bash
free -h
```

```bash
df -h
```

```bash
docker system df
```

## 18.8 Preserve the KIND cluster

Stop its node container without deleting the cluster:

```bash
docker stop devops-lab-control-plane
```

Restart:

```bash
docker start devops-lab-control-plane
```

Verify:

```bash
kubectl config use-context kind-devops-lab
```

```bash
kubectl get nodes
```

This preserves the Docker container while stopped, but other distributions can modify host networking.

If KIND does not recover, investigate before deleting anything.

## 18.9 Cluster inventory

Create backup inventory directory:

```bash
mkdir -p ~/kubernetes-labs/day-04/cluster-comparison/backups
```

Export non-secret inventories:

```bash
kubectl get all -A -o wide \
  > ~/kubernetes-labs/day-04/cluster-comparison/backups/resources.txt
```

```bash
kubectl get pv,pvc -A \
  > ~/kubernetes-labs/day-04/cluster-comparison/backups/storage.txt
```

```bash
kubectl get namespaces \
  > ~/kubernetes-labs/day-04/cluster-comparison/backups/namespaces.txt
```

These inventories are not complete cluster backups.

They do not replace:

- Original manifests.
- Helm values.
- Storage backups.
- Cluster-state backups.
- Secure credential recovery procedures.

## 18.10 Choosing a distribution

Use KIND when:

- Testing Kubernetes manifests.
- Running disposable CI clusters.
- Learning Kubernetes internals.

Use Minikube when:

- Developing applications locally.
- Testing common Kubernetes features.
- Using convenient add-ons.

Use MicroK8s when:

- Working in Ubuntu environments.
- Wanting packaged Kubernetes with add-ons.
- Exploring edge or small-cluster operations.

Use K3s when:

- Operating lightweight Kubernetes.
- Building edge deployments.
- Running smaller server-based environments.

The final choice depends on workload requirements, available resources, operational expertise, and support expectations.

---

# 19. Managed Kubernetes and Enterprise Platforms

## 19.1 Self-managed versus managed Kubernetes

### Self-managed Kubernetes

The organization operates more of the Kubernetes control plane and node infrastructure.

### Managed Kubernetes

A cloud provider operates significant portions of the Kubernetes control plane.

The customer still manages applications, many security controls, workload configuration, and platform operations.

## 19.2 Amazon EKS

Amazon Elastic Kubernetes Service is AWS's managed Kubernetes offering.

Common integrations:

- IAM.
- VPC.
- EC2.
- ECR.
- EBS.
- EFS.
- AWS Load Balancers.
- CloudWatch.
- Route 53.
- Secrets Manager.

### EKS architecture

```text
AWS-managed EKS Control Plane
             |
             v
        Amazon VPC
             |
       +-----+-----+
       |           |
       v           v
   Node Group   Node Group
       |           |
       v           v
      Pods        Pods
```

### Common EKS compute models

- Managed node groups.
- Self-managed EC2 nodes.
- AWS Fargate for eligible Pods.
- EKS Auto Mode.

## 19.3 AWS IAM versus Kubernetes RBAC

AWS IAM controls access to AWS resources.

Kubernetes RBAC controls permissions within the Kubernetes API.

EKS authentication and access configuration connect AWS identities with Kubernetes access.

A user who can describe an EKS cluster in AWS does not automatically have unrestricted Kubernetes administrator access.

## 19.4 EKS CLI commands

List existing clusters, if permitted:

```bash
aws eks list-clusters \
  --region us-east-1
```

Configure kubeconfig for an existing cluster:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name EXISTING_CLUSTER_NAME
```

Do not execute with a placeholder name.

## 19.5 Google Kubernetes Engine

Google Kubernetes Engine is Google Cloud's managed Kubernetes offering.

Important modes:

### Standard

Provides more control over node-pool configuration.

### Autopilot

Automates more infrastructure and node management.

Common integrations:

- Google Cloud IAM.
- VPC.
- Artifact Registry.
- Persistent Disk.
- Filestore.
- Cloud Load Balancing.
- Cloud Logging.
- Cloud Monitoring.
- Secret Manager.
- Workload Identity Federation for GKE.

## 19.6 Azure Kubernetes Service

Azure Kubernetes Service is Microsoft's managed Kubernetes offering.

Common integrations:

- Microsoft Entra ID.
- Azure RBAC.
- Azure Virtual Network.
- Azure Container Registry.
- Azure Disk.
- Azure Files.
- Azure Load Balancer.
- Azure Monitor.
- Azure Key Vault.

## 19.7 OpenShift

Red Hat OpenShift is an enterprise Kubernetes application platform.

It provides Kubernetes with additional integrated platform capabilities.

Important concepts:

- OpenShift projects.
- Routes.
- Operators.
- Security Context Constraints.
- Integrated web console.
- `oc` CLI.

Example:

```bash
oc get pods -A
```

Create project:

```bash
oc new-project development
```

OpenShift may enforce restrictive workload security policies.

Applications should avoid unnecessary root privileges and assumptions about writable filesystem locations.

## 19.8 Rancher

Rancher is a Kubernetes management platform.

It can provide centralized visibility and management across supported Kubernetes clusters.

Example:

```text
Rancher Management Server
           |
     +-----+------+
     |     |      |
     v     v      v
    EKS   GKE    K3s
```

Rancher does not replace the Kubernetes API server in an imported cluster.

## 19.9 Horizontal Pod Autoscaler

HPA adjusts the desired number of replicas for supported workloads.

Example:

```bash
kubectl autoscale deployment scaling-demo \
  --cpu-percent=50 \
  --min=2 \
  --max=5 \
  -n scaling-lab
```

Inspect:

```bash
kubectl get hpa -n scaling-lab
```

HPA requires a functioning metrics source for CPU-based scaling.

## 19.10 HPA versus node autoscaling

HPA:

```text
Changes workload replica count.
```

Node autoscaler:

```text
Changes cluster compute capacity.
```

HPA does not directly create EC2 instances.

Node autoscaling may use tools such as Cluster Autoscaler, Karpenter, or provider-specific mechanisms.

## 19.11 Production Kubernetes considerations

A production platform should address:

- High availability.
- Multiple failure domains.
- Network design.
- IAM and RBAC.
- Secrets management.
- Persistent storage.
- Backup and disaster recovery.
- Autoscaling.
- Observability.
- Cluster upgrades.
- Security policies.
- Cost management.
- Incident response.
- CI/CD and GitOps.

## 19.12 When not to use Kubernetes

Kubernetes is not always the most economical solution.

For small or intermittent workloads, simpler deployment options may be preferable.

Examples include:

- Managed container applications.
- Serverless container platforms.
- Platform-as-a-Service offerings.

This is relevant to our National Vehicle Registry project, where moving from Kubernetes-based infrastructure to Cloud Run reduced operational cost.

Good engineering means choosing the appropriate platform for the workload rather than automatically choosing the most complex technology.

---

# 20. Final Project: Deploying devops-cicd-lab

## 20.1 Project objective

The final Kubernetes project connects the application we developed during Day 2 and containerized during Day 3.

We will deploy the application using:

- Namespace.
- ConfigMap.
- Private registry authentication.
- Deployment.
- Service.
- Startup probe.
- Readiness probe.
- Liveness probe.
- Resource requests and limits.
- Kustomize.
- Rolling updates.
- Scaling.
- Logs and troubleshooting.

## 20.2 Application overview

Repository:

```text
devops-cicd-lab
```

Application:

```text
Node.js / Express
```

Endpoints:

```text
GET /
GET /health
```

Container image:

```text
ghcr.io/uvereann/devops-cicd-lab:latest
```

The application uses a multi-stage Dockerfile with a distroless non-root runtime.

## 20.3 Final architecture

```text
GitHub Repository
       |
       v
GitHub Actions
       |
       v
Docker Build
       |
       v
GHCR Private Image
       |
       v
KIND Kubernetes Cluster
       |
       v
Namespace: devops-app
       |
       +--------------------------+
       |                          |
       v                          v
  ConfigMap                 Image Pull Secret
       |                          |
       +------------+-------------+
                    |
                    v
                Deployment
                    |
                    v
                 ReplicaSet
                    |
              +-----+-----+
              |           |
              v           v
           Pod 1         Pod 2
              |           |
              +-----+-----+
                    |
                    v
              ClusterIP Service
                    |
                    v
              Port Forwarding
                    |
                    v
              HTTP Client
```

## 20.4 Proposed application repository structure

The Kubernetes manifests should live alongside the application source.

```text
devops-cicd-lab/
├── app/
├── Dockerfile
├── package.json
├── package-lock.json
├── .github/
│   └── workflows/
└── kubernetes/
    ├── base/
    │   ├── namespace.yaml
    │   ├── configmap.yaml
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   └── kustomization.yaml
    └── overlays/
        ├── development/
        └── production/
```

This is a recommended organization for integrating Kubernetes into the existing repository.

Do not overwrite existing application files or workflows without reviewing them.

## 20.5 Verify the actual application port

Before applying the following manifests, inspect the Node.js source and Dockerfile.

For example:

```bash
grep -R "listen(" app/ .
```

Review the output rather than assuming every match is relevant.

Also inspect:

```bash
cat Dockerfile
```

The following examples use port `3000`.

If the application listens on another port, update the Deployment and Service accordingly.

## 20.6 Prepare the KIND cluster

```bash
kubectl config current-context
```

Expected:

```text
kind-devops-lab
```

Check:

```bash
kubectl get nodes
```

The node should be Ready.

## 20.7 Create the final-project directory

```bash
mkdir -p ~/kubernetes-labs/day-04/final-project
```

```bash
cd ~/kubernetes-labs/day-04/final-project
```

## 20.8 Namespace manifest

Create `namespace.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: devops-app
  labels:
    environment: development
    project: devops-cicd-lab
```

Apply:

```bash
kubectl apply -f namespace.yaml
```

Verify:

```bash
kubectl get namespace devops-app
```

## 20.9 ConfigMap manifest

Create `configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: devops-app-config
  namespace: devops-app
data:
  NODE_ENV: "production"
  APP_ENV: "development"
  LOG_LEVEL: "info"
```

### Explanation

`NODE_ENV` identifies the Node.js runtime environment.

`APP_ENV` provides an application-specific environment label.

`LOG_LEVEL` can be used by applications that implement configurable logging.

These variables do not automatically change application behavior unless the application reads them.

## 20.10 GHCR authentication

Our private image requires registry authorization.

Create a suitable registry Secret in:

```text
devops-app
```

Secret name:

```text
ghcr-secret
```

Do not store the actual token in the repository.

The Deployment will reference:

```yaml
imagePullSecrets:
  - name: ghcr-secret
```

## 20.11 Deployment manifest

Create `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-cicd-lab
  namespace: devops-app
  labels:
    app: devops-cicd-lab

spec:
  replicas: 2

  revisionHistoryLimit: 5

  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0

  selector:
    matchLabels:
      app: devops-cicd-lab

  template:
    metadata:
      labels:
        app: devops-cicd-lab

    spec:
      imagePullSecrets:
        - name: ghcr-secret

      securityContext:
        runAsNonRoot: true
        seccompProfile:
          type: RuntimeDefault

      containers:
        - name: devops-cicd-lab

          image: ghcr.io/uvereann/devops-cicd-lab:latest
          imagePullPolicy: Always

          ports:
            - name: http
              containerPort: 3000

          envFrom:
            - configMapRef:
                name: devops-app-config

          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL

          startupProbe:
            httpGet:
              path: /health
              port: http
            periodSeconds: 5
            failureThreshold: 12

          readinessProbe:
            httpGet:
              path: /health
              port: http
            periodSeconds: 5
            failureThreshold: 3

          livenessProbe:
            httpGet:
              path: /health
              port: http
            periodSeconds: 10
            failureThreshold: 3

          resources:
            requests:
              cpu: "100m"
              memory: "64Mi"

            limits:
              cpu: "500m"
              memory: "256Mi"
```

## 20.12 Deployment explanation

### replicas

```yaml
replicas: 2
```

Requests two application Pods.

### RollingUpdate

```yaml
maxSurge: 1
maxUnavailable: 0
```

Allows one additional Pod during rollout while aiming to preserve existing availability.

### imagePullSecrets

```yaml
imagePullSecrets:
  - name: ghcr-secret
```

Allows Kubernetes to authenticate to the private registry.

### runAsNonRoot

```yaml
runAsNonRoot: true
```

Requires the container to run without root privileges.

This aligns with our distroless non-root image design.

### Startup probe

Allows the application time to start.

### Readiness probe

Determines whether the application should receive Service traffic.

### Liveness probe

Detects application health failures that should trigger container restart.

### Resource requests

Influence scheduling.

### Resource limits

Constrain resource consumption.

## 20.13 Service manifest

Create `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: devops-cicd-lab-service
  namespace: devops-app

spec:
  type: ClusterIP

  selector:
    app: devops-cicd-lab

  ports:
    - name: http
      port: 80
      targetPort: http
```

### Explanation

The Service exposes port 80 inside the cluster.

`targetPort: http` refers to the named container port:

```yaml
ports:
  - name: http
    containerPort: 3000
```

## 20.14 Kustomization manifest

Create `kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - namespace.yaml
  - configmap.yaml
  - deployment.yaml
  - service.yaml
```

## 20.15 Validate manifests

```bash
kubectl kustomize .
```

Dry-run:

```bash
kubectl apply --dry-run=client -k .
```

Client-side dry-run is not a substitute for all server-side validation or runtime testing.

## 20.16 Deploy the application

```bash
kubectl apply -k .
```

Verify:

```bash
kubectl get deployments -n devops-app
```

```bash
kubectl get pods -n devops-app
```

```bash
kubectl get services -n devops-app
```

Wait for rollout:

```bash
kubectl rollout status deployment/devops-cicd-lab \
  -n devops-app \
  --timeout=180s
```

Expected after a successful deployment:

```text
READY
2/2
```

This result depends on successful image authentication, application startup, health checks, and available resources.

## 20.17 Troubleshoot image pulling

If Pods show:

```text
ImagePullBackOff
```

Run:

```bash
kubectl describe pod POD_NAME -n devops-app
```

Check:

- Image name.
- Tag availability.
- Secret existence.
- Package access permissions.
- Namespace.
- Registry connectivity.

## 20.18 Troubleshoot application startup

If Pods show:

```text
CrashLoopBackOff
```

Run:

```bash
kubectl logs deployment/devops-cicd-lab \
  -n devops-app
```

Inspect previous logs if appropriate:

```bash
kubectl logs POD_NAME \
  -n devops-app \
  --previous
```

Possible causes:

- Wrong application entry point.
- Missing runtime dependencies.
- Incorrect environment variables.
- Application exception.
- File permissions.
- Image/runtime incompatibility.

## 20.19 Troubleshoot readiness failures

If Pods show:

```text
Running
0/1 Ready
```

Check:

```bash
kubectl describe pod POD_NAME -n devops-app
```

Verify:

- Application port.
- `/health` endpoint.
- Probe path.
- Probe timing.
- Application binding address.

The application should listen on an interface reachable from the Pod network, typically `0.0.0.0`, rather than only `127.0.0.1`.

## 20.20 Test application connectivity

Start port-forwarding:

```bash
kubectl port-forward \
  -n devops-app \
  service/devops-cicd-lab-service \
  8085:80
```

From another EC2 terminal:

```bash
curl -i http://127.0.0.1:8085/
```

Health endpoint:

```bash
curl -i http://127.0.0.1:8085/health
```

Expected: successful HTTP responses when the application is healthy.

## 20.21 Scale the application

```bash
kubectl scale deployment/devops-cicd-lab \
  --replicas=3 \
  -n devops-app
```

Verify:

```bash
kubectl get pods -n devops-app
```

Scale back:

```bash
kubectl scale deployment/devops-cicd-lab \
  --replicas=2 \
  -n devops-app
```

## 20.22 Rolling update experiment

Trigger a Pod-template change:

```bash
kubectl patch deployment devops-cicd-lab \
  -n devops-app \
  --type=merge \
  -p '{"spec":{"template":{"metadata":{"annotations":{"lab-revision":"2"}}}}}'
```

Wait:

```bash
kubectl rollout status deployment/devops-cicd-lab \
  -n devops-app
```

Inspect:

```bash
kubectl rollout history deployment/devops-cicd-lab \
  -n devops-app
```

Rollback:

```bash
kubectl rollout undo deployment/devops-cicd-lab \
  -n devops-app
```

Verify:

```bash
kubectl rollout status deployment/devops-cicd-lab \
  -n devops-app
```

## 20.23 Logs and metrics

Application logs:

```bash
kubectl logs deployment/devops-cicd-lab \
  -n devops-app \
  --tail=100
```

Follow logs:

```bash
kubectl logs deployment/devops-cicd-lab \
  -n devops-app \
  -f
```

Resource metrics:

```bash
kubectl top pods -n devops-app
```

Events:

```bash
kubectl get events -n devops-app \
  --sort-by=.metadata.creationTimestamp
```

## 20.24 Final verification

```bash
kubectl config current-context
```

```bash
kubectl get nodes
```

```bash
kubectl get all -n devops-app
```

```bash
kubectl get configmaps -n devops-app
```

```bash
kubectl get secrets -n devops-app
```

```bash
kubectl rollout history deployment/devops-cicd-lab \
  -n devops-app
```

## 20.25 Production improvements

Before deploying the application to production, consider:

1. Use an immutable image digest instead of relying on `latest`.
2. Configure appropriate external DNS and TLS.
3. Use a secure production image registry authentication strategy.
4. Integrate with an external secret-management system.
5. Configure centralized logging.
6. Add application metrics and alerting.
7. Add PodDisruptionBudgets where appropriate.
8. Configure multiple nodes and failure domains.
9. Use production-ready storage for stateful dependencies.
10. Apply NetworkPolicies with a supporting CNI.
11. Add CI/CD deployment approvals.
12. Configure workload autoscaling.
13. Configure appropriate ServiceAccounts and RBAC.
14. Perform vulnerability and dependency scanning.
15. Test backup and recovery procedures.

---

# 21. Kubernetes and CI/CD Integration

## 21.1 Why integrate Kubernetes with CI/CD?

A modern delivery workflow should automate:

- Code validation.
- Unit testing.
- Dependency checks.
- Container image builds.
- Security scanning.
- Image publishing.
- Deployment configuration updates.
- Deployment verification.

## 21.2 Our continuous project

```text
Developer Push
      |
      v
GitHub
      |
      v
GitHub Actions
      |
      v
Node.js Tests
      |
      v
Docker Build
      |
      v
Security Scanning
      |
      v
GHCR
      |
      v
Kubernetes Deployment
      |
      v
Rollout Verification
```

## 21.3 CI versus CD

### Continuous Integration

Automates code integration checks.

Examples:

- Tests.
- Linting.
- Build validation.
- Security scanning.

### Continuous Delivery

Ensures software is ready for deployment, often with an approval step.

### Continuous Deployment

Automatically deploys changes that pass the required pipeline controls.

## 21.4 Example GitHub Actions CI workflow

The following is an illustrative workflow for the existing Node.js application.

It must be reconciled with the actual workflow already present in `devops-cicd-lab` before use.

```yaml
name: Node.js CI

on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "24"
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test
```

This assumes the application has a functioning `npm test` script.

If it does not, the workflow must be updated to use the project's actual validation commands.

For production workflows, pin third-party actions to reviewed immutable commit SHAs.

## 21.5 Example GHCR publishing workflow

```yaml
name: Publish Container Image

on:
  push:
    branches:
      - main

permissions:
  contents: read
  packages: write

jobs:
  publish:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build image
        run: |
          docker build \
            -t ghcr.io/uvereann/devops-cicd-lab:${{ github.sha }} \
            .

      - name: Push image
        run: |
          docker push \
            ghcr.io/uvereann/devops-cicd-lab:${{ github.sha }}
```

This example assumes the workflow has permission to publish to the target GHCR package.

It should not be copied over an existing workflow without checking package permissions and current pipeline behavior.

## 21.6 Why immutable image references matter

Avoid relying only on:

```text
latest
```

Prefer versioned tags or immutable digests.

Example:

```text
ghcr.io/uvereann/devops-cicd-lab:<commit-sha>
```

A digest provides stronger immutability guarantees:

```text
ghcr.io/uvereann/devops-cicd-lab@sha256:<digest>
```

This helps ensure the exact tested image is deployed.

## 21.7 GitOps

GitOps uses Git as the source of truth for desired infrastructure or application configuration.

A GitOps controller reconciles cluster state with approved Git configuration.

Common tools:

- Argo CD.
- Flux.

### GitOps flow

```text
Developer
    |
    v
Git Repository
    |
    v
Pull Request Review
    |
    v
Approved Manifests
    |
    v
GitOps Controller
    |
    v
Kubernetes Cluster
```

## 21.8 CI/CD versus GitOps

| CI/CD | GitOps |
|---|---|
| Builds and tests applications | Reconciles deployed configuration |
| Publishes artifacts | Watches approved desired state |
| May push deployments directly | Commonly uses pull-based reconciliation |
| Can trigger releases | Detects and corrects drift |

These approaches can work together.

Example:

```text
GitHub Actions builds image.
GitHub Actions updates approved image reference.
Argo CD detects manifest change.
Argo CD reconciles Kubernetes Deployment.
```

## 21.9 Security considerations

- Avoid storing kubeconfig in source control.
- Prefer short-lived workload identities.
- Restrict deployment permissions.
- Protect production environments with approvals.
- Scan container images.
- Review third-party GitHub Actions.
- Use immutable image references.
- Avoid printing secrets in logs.

---

# 22. Kubernetes Command Cheat Sheet

## Cluster information

```bash
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl get namespaces
kubectl get pods -A
```

## Context management

```bash
kubectl config get-contexts
kubectl config current-context
kubectl config use-context kind-devops-lab
```

## Pods

```bash
kubectl get pods
kubectl get pods -o wide
kubectl describe pod POD_NAME
kubectl logs POD_NAME
kubectl logs POD_NAME --previous
kubectl logs -f POD_NAME
kubectl exec -it POD_NAME -- /bin/sh
kubectl delete pod POD_NAME
```

## Deployments

```bash
kubectl get deployments
kubectl describe deployment DEPLOYMENT_NAME
kubectl scale deployment DEPLOYMENT_NAME --replicas=3
kubectl rollout status deployment/DEPLOYMENT_NAME
kubectl rollout history deployment/DEPLOYMENT_NAME
kubectl rollout undo deployment/DEPLOYMENT_NAME
```

## Services

```bash
kubectl get services
kubectl describe service SERVICE_NAME
kubectl get endpointslices
kubectl port-forward service/SERVICE_NAME 8080:80
```

## Namespaces

```bash
kubectl create namespace development
kubectl get pods -n development
kubectl get pods -A
kubectl delete namespace TEMPORARY_NAMESPACE
```

## ConfigMaps

```bash
kubectl get configmaps
kubectl describe configmap CONFIGMAP_NAME
kubectl create configmap CONFIGMAP_NAME \
  --from-literal=KEY=value
```

## Secrets

```bash
kubectl get secrets
kubectl describe secret SECRET_NAME
```

Avoid exposing Secret values unnecessarily.

## Storage

```bash
kubectl get pv
kubectl get pvc -A
kubectl get storageclass
kubectl describe pvc PVC_NAME -n NAMESPACE
```

## Resource metrics

```bash
kubectl top nodes
kubectl top pods -A
```

Metrics Server or another compatible metrics API implementation is required.

## Events

```bash
kubectl get events -A
kubectl get events -n NAMESPACE \
  --sort-by=.metadata.creationTimestamp
```

## RBAC

```bash
kubectl get roles -A
kubectl get rolebindings -A
kubectl get clusterroles
kubectl get clusterrolebindings
kubectl auth can-i get pods
```

## Helm

```bash
helm version
helm list -A
helm lint CHART_DIRECTORY
helm template RELEASE CHART_DIRECTORY
helm install RELEASE CHART_DIRECTORY
helm upgrade RELEASE CHART_DIRECTORY
helm history RELEASE
helm rollback RELEASE REVISION
```

## Kustomize

```bash
kubectl kustomize DIRECTORY
kubectl apply -k DIRECTORY
kubectl delete -k DIRECTORY
```

## KIND

```bash
kind version
kind get clusters
kind create cluster --name devops-lab
kubectl config use-context kind-devops-lab
```

---

# 23. Troubleshooting Reference

## 23.1 CrashLoopBackOff

### Meaning

A container repeatedly fails and Kubernetes applies a restart backoff.

### Investigation

```bash
kubectl describe pod POD_NAME
```

```bash
kubectl logs POD_NAME
```

```bash
kubectl logs POD_NAME --previous
```

### Common causes

- Application exception.
- Incorrect command.
- Missing configuration.
- Permission errors.
- Dependency failures.
- Resource exhaustion.

## 23.2 ImagePullBackOff

### Meaning

Kubernetes cannot successfully pull the requested image.

### Investigation

```bash
kubectl describe pod POD_NAME
```

### Common causes

- Invalid image name.
- Missing tag.
- Registry authentication failure.
- Insufficient permissions.
- Network problems.

## 23.3 Pending Pod

### Meaning

The Pod has not successfully reached its running state.

### Investigation

```bash
kubectl describe pod POD_NAME
```

### Common causes

- Insufficient CPU or memory.
- Node selector mismatch.
- Taints.
- PVC constraints.
- Unavailable nodes.
- Scheduling restrictions.

## 23.4 CreateContainerConfigError

### Meaning

The container cannot be configured for startup.

### Common causes

- Missing ConfigMap.
- Missing Secret.
- Missing referenced key.
- Invalid configuration reference.

## 23.5 Running but Not Ready

### Investigation

```bash
kubectl describe pod POD_NAME
```

Check:

- Readiness probe.
- Application port.
- Health endpoint.
- Application dependencies.
- Startup timing.

## 23.6 Service not reachable

### Investigation sequence

```bash
kubectl get service SERVICE_NAME
```

```bash
kubectl describe service SERVICE_NAME
```

```bash
kubectl get pods --show-labels
```

```bash
kubectl get endpointslices
```

Check:

- Service selector.
- Pod labels.
- Endpoint readiness.
- Service port.
- Target port.
- NetworkPolicy.
- Application listener.

## 23.7 DNS failure

Check:

```bash
kubectl get pods -n kube-system
```

```bash
kubectl get service kube-dns -n kube-system
```

Test DNS from a temporary Pod.

Check:

- Service name.
- Namespace.
- DNS configuration.
- CoreDNS health.
- Network restrictions.

## 23.8 PVC Pending

Check:

```bash
kubectl describe pvc PVC_NAME -n NAMESPACE
```

```bash
kubectl get storageclass
```

```bash
kubectl get pv
```

Check:

- StorageClass.
- Available capacity.
- Access mode.
- Provisioner.
- Node affinity.
- Binding mode.

## 23.9 OOMKilled

Check:

```bash
kubectl describe pod POD_NAME
```

Investigate:

- Memory limit.
- Actual memory usage.
- Application behavior.
- Memory leaks.
- Workload demand.

## 23.10 Failed rollout

Check:

```bash
kubectl rollout status deployment/DEPLOYMENT_NAME
```

```bash
kubectl describe deployment DEPLOYMENT_NAME
```

```bash
kubectl get pods
```

```bash
kubectl get events
```

If a previous healthy revision exists, consider:

```bash
kubectl rollout undo deployment/DEPLOYMENT_NAME
```

## 23.11 Node NotReady

Check:

```bash
kubectl get nodes
```

```bash
kubectl describe node NODE_NAME
```

On self-managed nodes, inspect:

- kubelet.
- Container runtime.
- Host resources.
- Disk pressure.
- Memory pressure.
- Network connectivity.
- Node certificates.
- Control-plane reachability.

## 23.12 A systematic troubleshooting checklist

1. Confirm the correct cluster context.
2. Confirm the namespace.
3. Check resource status.
4. Describe the failing resource.
5. Inspect Kubernetes events.
6. Read application logs.
7. Check configuration and image references.
8. Check Service selectors and endpoints.
9. Check DNS and networking.
10. Check storage dependencies.
11. Check resource requests and limits.
12. Check RBAC and security policies.
13. Apply a targeted fix.
14. Verify recovery.
15. Document the root cause and resolution.

---

# 24. Kubernetes Interview Questions and Answers

## Q1. What is Kubernetes?

Kubernetes is an open-source container orchestration platform that automates deployment, scheduling, scaling, networking, and management of containerized applications.

## Q2. Why use Kubernetes instead of Docker alone?

Docker provides container packaging and execution capabilities.

Kubernetes adds orchestration capabilities such as scheduling, replica management, self-healing, rolling updates, and cluster-level networking.

## Q3. What is a Pod?

A Pod is the smallest deployable Kubernetes workload unit.

It contains one or more containers sharing networking and configured storage.

## Q4. What is the difference between a Pod and a Deployment?

A Pod runs containers.

A Deployment manages replicated stateless workloads through ReplicaSets and supports rolling updates and rollbacks.

## Q5. What is a ReplicaSet?

A ReplicaSet maintains the desired number of matching Pod replicas.

Deployments usually manage ReplicaSets automatically.

## Q6. What happens when a Pod managed by a Deployment is deleted?

The ReplicaSet controller detects that the desired replica count is not satisfied and attempts to create a replacement Pod.

## Q7. What is the Kubernetes control plane?

The control plane manages cluster state and scheduling decisions.

Common components include the API server, scheduler, controller manager, and etcd.

## Q8. What does kube-apiserver do?

It exposes the Kubernetes API and processes authenticated, authorized, and validated resource requests.

## Q9. What does etcd do?

etcd stores Kubernetes cluster state in a distributed key-value store.

## Q10. What does the scheduler do?

The scheduler assigns unscheduled Pods to suitable nodes based on resource requirements and scheduling constraints.

## Q11. What does kubelet do?

The kubelet ensures assigned Pods run on a node according to their specifications.

## Q12. What is a Kubernetes Service?

A Service provides stable network access to a set of selected backend endpoints.

## Q13. What is ClusterIP?

ClusterIP exposes a Service through a cluster-internal virtual IP.

## Q14. What is NodePort?

NodePort exposes a Service through a configured port on eligible Kubernetes nodes.

## Q15. What is LoadBalancer?

A LoadBalancer Service requests integration with an external load-balancing implementation.

## Q16. How does a Service identify Pods?

A selector-based Service uses label selectors to identify matching Pods.

EndpointSlices represent the resulting backend endpoints.

## Q17. What is a Namespace?

A Namespace logically organizes namespaced Kubernetes resources.

It can support team separation, environment organization, and access-control boundaries.

## Q18. What is the difference between labels and annotations?

Labels identify and select resources.

Annotations store additional metadata that is not normally used for resource selection.

## Q19. What is a ConfigMap?

A ConfigMap stores non-sensitive configuration data that workloads can consume.

## Q20. What is a Secret?

A Secret stores sensitive configuration data such as credentials or tokens.

It still requires proper encryption, authorization, and operational security.

## Q21. Why do private container images need imagePullSecrets?

Private registries require authentication.

An imagePullSecret provides registry credentials to the workload's image-pulling process.

## Q22. What is a PersistentVolume?

A PersistentVolume represents storage available to Kubernetes workloads.

## Q23. What is a PersistentVolumeClaim?

A PVC requests persistent storage with specified capacity and access requirements.

## Q24. What is a StorageClass?

A StorageClass defines storage provisioning characteristics and the provisioner used to create volumes.

## Q25. What is the difference between readiness and liveness probes?

Readiness determines whether a container should receive normal Service traffic.

Liveness determines whether an unhealthy container should be restarted.

## Q26. What is a startup probe?

A startup probe checks whether an application has completed startup and delays readiness and liveness checks until startup succeeds.

## Q27. What are resource requests?

Requests describe resource requirements used by Kubernetes scheduling.

## Q28. What are resource limits?

Limits constrain resource usage.

CPU limits may cause throttling, while memory limits may lead to OOM kills.

## Q29. What is Ingress?

Ingress is a Kubernetes API resource defining HTTP/HTTPS routing rules to backend Services.

It requires an Ingress controller.

## Q30. What is an Ingress controller?

An Ingress controller implements Ingress routing rules.

Examples include Traefik and compatible NGINX-based controllers.

## Q31. What is Helm?

Helm is a Kubernetes package manager that uses charts to package and configure related Kubernetes resources.

## Q32. What is Kustomize?

Kustomize customizes Kubernetes YAML manifests using bases, overlays, and patches without requiring a template language.

## Q33. What is RBAC?

Role-Based Access Control is a Kubernetes authorization mechanism that defines what authenticated identities can do.

## Q34. What is a ServiceAccount?

A ServiceAccount provides an identity for workloads and automation interacting with Kubernetes.

## Q35. What is a NetworkPolicy?

A NetworkPolicy describes permitted traffic for selected Pods.

It requires a supporting network implementation for enforcement.

## Q36. What is a StatefulSet?

A StatefulSet manages workloads that need stable identities and ordered workload management.

## Q37. What is a DaemonSet?

A DaemonSet ensures Pods run on eligible cluster nodes.

## Q38. What is a Job?

A Job manages Pods that execute tasks to completion.

## Q39. What is a CronJob?

A CronJob schedules Jobs according to a cron expression.

## Q40. What is a nodeSelector?

A nodeSelector constrains Pod scheduling to nodes with matching labels.

## Q41. What are taints and tolerations?

Taints discourage or prevent Pods from scheduling on nodes unless they have appropriate tolerations.

## Q42. What causes CrashLoopBackOff?

Repeated container failures.

Possible causes include application crashes, invalid commands, missing dependencies, and configuration errors.

## Q43. What causes ImagePullBackOff?

Image retrieval failures caused by missing images, incorrect tags, authentication problems, or registry connectivity issues.

## Q44. How would you troubleshoot a Pending Pod?

I would inspect Pod events, node readiness, resource requests, node selectors, affinity, taints, tolerations, and storage constraints.

## Q45. How would you troubleshoot a Service that cannot reach its Pods?

I would verify Service selectors, Pod labels, EndpointSlices, Pod readiness, ports, DNS, and network policies.

## Q46. What is KIND?

KIND is a Kubernetes testing and development tool that runs Kubernetes nodes inside Docker containers.

## Q47. What is Minikube?

Minikube simplifies local Kubernetes development and provides convenient cluster and add-on management.

## Q48. What is MicroK8s?

MicroK8s is a packaged Kubernetes distribution maintained by Canonical.

## Q49. What is K3s?

K3s is a lightweight Kubernetes distribution commonly used for edge, small-server, and other environments.

## Q50. What is Amazon EKS?

EKS is AWS's managed Kubernetes service.

## Q51. What is GKE?

GKE is Google Cloud's managed Kubernetes service.

## Q52. What is AKS?

AKS is Microsoft's managed Kubernetes service.

## Q53. What is Rancher?

Rancher is a Kubernetes management platform that supports centralized management of Kubernetes clusters.

## Q54. What is OpenShift?

OpenShift is Red Hat's enterprise Kubernetes application platform with integrated operational and developer capabilities.

## Q55. What is Horizontal Pod Autoscaler?

HPA adjusts the desired number of replicas for supported workloads based on configured metrics.

## Q56. Does HPA automatically create worker nodes?

No.

HPA changes workload replica counts.

Node autoscaling is a separate capability.

## Q57. What is GitOps?

GitOps uses version-controlled desired configuration and automated reconciliation to manage deployed systems.

## Q58. How would you secure Kubernetes in production?

I would implement least-privilege IAM and RBAC, restrict network access, use secure workload identities, scan container images, manage secrets securely, apply admission policies, configure observability, and maintain a patching and incident-response process.

## Q59. How would you perform a production Kubernetes upgrade?

I would review version compatibility, deprecated APIs, add-on support, workload disruption risks, and backup/recovery plans.

I would test in staging, upgrade in the supported order, validate workloads, and monitor the environment.

## Q60. Explain our devops-cicd-lab Kubernetes deployment.

We developed a Node.js/Express application, containerized it using a multi-stage Dockerfile, and published its image to GitHub Container Registry.

For Kubernetes, we defined a namespace, ConfigMap, Deployment, and Service.

The Deployment uses two replicas, image-pull authentication for the private registry, non-root security settings, health probes, and resource requests and limits.

The Service provides stable internal access to the application.

We practiced validating manifests, deploying with Kustomize, checking Pod health, testing application endpoints, scaling, rolling updates, rollback, logs, and troubleshooting.

This project demonstrates how Git, CI/CD, Docker, container registries, and Kubernetes fit into a single DevOps workflow.

---

# 25. Lessons Learned and Next Steps

## 25.1 Key lessons

During Day 4, we learned that Kubernetes is much more than a container runtime.

It is a platform for describing and managing desired application state.

Important lessons include:

### Kubernetes is declarative

We define the desired state using Kubernetes API resources.

Controllers continuously reconcile the actual state.

### Pods are disposable

Applications should not rely on a Pod's identity or writable container filesystem for permanent storage.

### Deployments manage availability

Deployments provide replica management, self-healing, rolling updates, and rollbacks.

### Services provide stable access

Services decouple application clients from changing Pod IP addresses.

### Configuration should be externalized

ConfigMaps and Secrets separate application configuration from container images.

### Persistent storage requires careful design

Storage availability depends on the underlying storage implementation.

A PVC alone does not guarantee high availability or backups.

### Health checks improve reliability

Startup, readiness, and liveness probes help Kubernetes understand application state.

### Security requires multiple layers

RBAC, workload identity, network controls, container hardening, and secret management work together.

### Troubleshooting requires a systematic approach

Effective diagnosis uses:

```text
Status
  |
  v
Describe
  |
  v
Events
  |
  v
Logs
  |
  v
Configuration
  |
  v
Root Cause
  |
  v
Fix
  |
  v
Verification
```

### Kubernetes distributions have different purposes

KIND, Minikube, MicroK8s, K3s, EKS, GKE, AKS, and OpenShift serve different operational needs.

### Kubernetes is not always the best deployment option

The right platform depends on workload size, reliability requirements, team expertise, and cost.

## 25.2 Skills gained

- Kubernetes architecture.
- kubectl administration.
- Pod management.
- Deployment management.
- Service networking.
- DNS troubleshooting.
- Configuration management.
- Persistent storage.
- Health probes.
- Resource management.
- Ingress routing.
- Headlamp GUI.
- Helm.
- Kustomize.
- RBAC.
- ServiceAccounts.
- NetworkPolicies.
- StatefulSets.
- DaemonSets.
- Jobs.
- CronJobs.
- Scheduling.
- Kubernetes troubleshooting.
- Metrics and observability.
- Kubernetes distribution comparison.
- Managed Kubernetes architecture.
- CI/CD and GitOps integration.

## 25.3 Final project summary

**Project:** `devops-cicd-lab`

**Application:** Node.js/Express

**Container registry:** GitHub Container Registry

**Kubernetes environment:** AWS EC2-hosted KIND cluster

**Deployment resources:**

- Namespace.
- ConfigMap.
- Registry Secret.
- Deployment.
- Service.
- Kustomization.

**Operational exercises:**

- Image pulling.
- Application startup.
- Health checks.
- Service connectivity.
- Scaling.
- Rolling updates.
- Rollbacks.
- Logs.
- Metrics.
- Troubleshooting.

## 25.4 Repository responsibilities

### Application repository

```text
devops-cicd-lab
```

Contains the actual application and deployment implementation.

### Documentation repository

```text
7-day-devops-refresh/day-04-kubernetes/README.md
```

Contains the complete learning guide, explanations, commands, examples, and troubleshooting reference.

## 25.5 Next learning phase

The next phase of the seven-day refresh is:

**Day 5 — Terraform and Cloud Infrastructure**

Topics include:

- Infrastructure as Code.
- Terraform architecture.
- Providers and resources.
- Variables and outputs.
- State management.
- Modules.
- AWS networking.
- EC2 provisioning.
- Security groups.
- Terraform plan and apply.
- Terraform troubleshooting.
- Infrastructure lifecycle management.
- CI/CD integration.

The goal is to connect Kubernetes application deployment with automated infrastructure provisioning.

---

# Day 4 Completion Checklist

- [x] Kubernetes fundamentals
- [x] Kubernetes architecture
- [x] Kubernetes cluster setup
- [x] kubectl fundamentals
- [x] Pods and container lifecycle
- [x] Deployments and ReplicaSets
- [x] Scaling and rolling updates
- [x] Services and networking
- [x] Namespaces and labels
- [x] ConfigMaps and Secrets
- [x] Persistent storage
- [x] Health probes
- [x] Resource management
- [x] Ingress and DNS
- [x] Kubernetes GUI
- [x] Helm and Kustomize
- [x] RBAC and security
- [x] Advanced workloads
- [x] Scheduling
- [x] Troubleshooting
- [x] Observability
- [x] Kubernetes distributions
- [x] Managed Kubernetes concepts
- [x] Final application deployment exercises
- [x] Interview preparation

---

# References

Official documentation for further study:

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [KIND Documentation](https://kind.sigs.k8s.io/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [MicroK8s Documentation](https://microk8s.io/docs)
- [K3s Documentation](https://docs.k3s.io/)
- [Helm Documentation](https://helm.sh/docs/)
- [Kustomize Documentation](https://kubectl.docs.kubernetes.io/references/kustomize/)
- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [Headlamp Documentation](https://headlamp.dev/)
- [Rancher Documentation](https://ranchermanager.docs.rancher.com/)
- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Google Kubernetes Engine Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [Azure Kubernetes Service Documentation](https://learn.microsoft.com/en-us/azure/aks/)
- [OpenShift Documentation](https://docs.redhat.com/en/documentation/openshift_container_platform/)
- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Flux Documentation](https://fluxcd.io/flux/)

---

**End of Day 4 — Kubernetes**

**7-Day DevOps Refresh | Linux → Git/CI/CD → Docker → Kubernetes → Terraform/Cloud → Observability/DevSecOps/GitOps → Interview Preparation**