# Day 03 — Docker: From Fundamentals to Production-Ready Containers

> **7-Day DevOps Refresh | Day 3 | Complete follow-along learning guide**  
> **Learning method:** Understand → Visualize → Practice → Verify → Break/Fix → Explain → Interview  
> **Main lab:** `devops-cicd-lab` — Node.js/Express, Docker, Docker Compose, GitHub Actions, Trivy, and GitHub Container Registry (GHCR)

---

## How to use this guide

This README is a **hands-on textbook**, not an activity report. Work through it in order, run the commands, understand *why* each command works, and complete the troubleshooting challenges. Commands are written for **Ubuntu/Linux** with a Bash shell. The exercises deliberately separate **safe inspection commands** from commands that create, modify, or delete resources.

**Conventions**

- `$` represents a terminal prompt; do not type it.
- Replace placeholders such as `<container>` or `<YOUR_GITHUB_USERNAME>` with your own values.
- The example image `ghcr.io/uvereann/devops-cicd-lab:latest` belongs to the reference lab; substitute your own image when following independently.
- The project uses port **3000** internally; Compose also demonstrates a reverse proxy on host port **8080**.
- A few exercises may pull images. On a low-resource laptop, check image sizes and free space before downloading.
- **Never paste tokens into commands, Git files, screenshots, or documentation.**

### Learning outcomes

By the end, you should be able to:

1. Explain containers, images, registries, layers, namespaces, cgroups, and the Docker Engine.
2. Build, tag, run, inspect, stop, remove, and troubleshoot containers.
3. Write a maintainable Dockerfile, explain every instruction, and optimize layer caching.
4. Explain storage persistence, volumes, bind mounts, networking, port mapping, and DNS.
5. Define a multi-service application with Docker Compose.
6. Build a multi-stage production image using a minimal, non-root runtime.
7. Test, scan, and publish Docker images using GitHub Actions and GHCR.
8. Diagnose failures systematically and apply sensible runtime security controls.
9. Answer common DevOps/Platform Engineer interview questions with practical examples.

### Prerequisites

- Ubuntu with Docker Engine and the Compose plugin installed; Docker Buildx available.
- Git and a GitHub account; Node.js/npm useful for local application tests.
- A terminal and editor (VS Code is fine).
- Basic familiarity with Linux files, ports, and Git.

Check your environment:

```bash
docker --version
docker compose version
docker buildx version
docker info
git --version
node --version
npm --version
```

If `docker` is unavailable, install Docker Engine and the Compose plugin using Docker's official Ubuntu instructions. If you see `permission denied` on `/var/run/docker.sock`, verify that the Docker daemon is running and that your account has permission to access it. **Membership in the `docker` group effectively grants root-level control of the host; do not treat it as a harmless permission change.** Avoid blindly changing socket permissions with `chmod 777`.

Useful diagnostics:

```bash
sudo systemctl status docker
ls -l /var/run/docker.sock
groups
```

---

# Module 1 — What problem does Docker solve?

## 1.1 The classic “works on my machine” problem

A Node.js app works on a developer's laptop but fails on a server because the Node version, dependencies, environment variables, or operating-system libraries differ. Docker helps package an application and its user-space dependencies into a portable image that can be run consistently wherever a compatible container runtime exists.

**Docker does not package a separate Linux kernel.** Linux containers share the host kernel. A container is generally lighter than a virtual machine because it does not require a full guest operating system.

| Virtual machine | Container |
|---|---|
| Virtualizes hardware; includes guest OS/kernel | Isolates processes while sharing the host kernel |
| Often larger and slower to start | Often smaller and faster to start |
| Stronger isolation boundary in many deployments | Isolation depends on kernel and runtime configuration |
| Suitable for different guest operating systems | Linux containers need a compatible Linux kernel/runtime |

**Mental model:** A Docker **image** is the packaged blueprint; a **container** is an instance of that blueprint; a **registry** stores and distributes images.

```text
Source code + Dockerfile
          |
          v
     docker build
          |
          v
    Docker IMAGE  ---- docker push ----> REGISTRY (GHCR/Docker Hub)
          |
       docker run
          |
          v
    Docker CONTAINER ---- published port ----> Browser / Client
```

## 1.2 Docker architecture

- **Docker CLI:** The `docker` command you type.
- **Docker daemon (`dockerd`):** Manages images, containers, networks, and volumes.
- **Docker Engine:** Client/server platform used to build and run containers.
- **Container runtime:** Runs isolated processes; Docker commonly uses containerd and an OCI runtime such as runc.
- **Registry:** Stores image manifests and layers.
- **Buildx/BuildKit:** Modern Docker build tooling with efficient caching and advanced build features.

Linux isolation relies on mechanisms such as **namespaces** (separate views of processes, networking, mounts, etc.) and **cgroups** (resource accounting and limits). Security also depends on capabilities, seccomp, filesystem permissions, and the host's patch level.

### Knowledge check

1. Why is a container not the same as a VM?
2. Does a Docker image execute by itself?
3. Does `docker push` deploy an application to a server?

**Answers:** (1) Containers share a kernel; VMs usually have their own guest kernel. (2) No, create/run a container from it. (3) No, pushing stores an image in a registry; a runtime must pull and run it.

---

# Module 2 — Images and container lifecycle

## 2.1 Essential commands

| Command | Purpose |
|---|---|
| `docker image ls` / `docker images` | List local images |
| `docker ps` | List running containers |
| `docker ps -a` | List running and stopped containers |
| `docker pull IMAGE` | Download image metadata and layers |
| `docker run IMAGE` | Create and start a container |
| `docker start NAME` | Start an existing stopped container |
| `docker stop NAME` | Request graceful shutdown |
| `docker restart NAME` | Restart an existing container |
| `docker rm NAME` | Remove a stopped container |
| `docker rmi IMAGE` | Remove an image reference/local image if unused |
| `docker logs NAME` | Show container stdout/stderr |
| `docker inspect NAME` | Show detailed configuration/state |
| `docker exec NAME COMMAND` | Execute a command in a running container, if the executable exists |
| `docker stats --no-stream` | Take one resource usage snapshot |
| `docker system df` | Show Docker disk usage |

**Important distinction:** `docker run` creates a **new** container. `docker start` starts an **existing** container. `docker stop` does not delete it.

## 2.2 First lab: inspect before changing anything

```bash
docker image ls
docker ps
docker ps -a
docker system df
```

Explain each column in `docker ps`: container ID, image, command, creation time, status, ports, and name.

If you already have the lab image locally, list it:

```bash
docker image ls ghcr.io/uvereann/devops-cicd-lab
```

**Optional:** If you have authenticated to its private registry and need to download it, use `docker pull`; otherwise, build your own image in Module 4. Pulling consumes disk space.

## 2.3 Run the real Express lab image

After building the image locally or pulling an authorized copy, choose the image reference you actually have. For the GHCR example:

```bash
docker run -d \
  --name devops-web \
  -p 3000:3000 \
  ghcr.io/uvereann/devops-cicd-lab:latest
```

- `-d`: detached/background mode.
- `--name`: readable container name.
- `-p HOST_PORT:CONTAINER_PORT`: publishes container port 3000 on host port 3000.
- Last argument: image reference.

Verify:

```bash
docker ps
docker logs --tail 20 devops-web
curl -i http://localhost:3000/
curl -i http://localhost:3000/health
```

The reference application's `/` endpoint returns JSON resembling:

```json
{"message":"DevOps CI/CD Lab","status":"running"}
```

**Why JSON, not a visual webpage?** This lab is an Express API, not a React frontend. The browser renders the response it receives. A Dockerized frontend could serve full HTML/CSS/React UI in exactly the same way.

### Container lifecycle lab

```bash
docker stop devops-web
docker ps
docker ps -a
docker start devops-web
docker logs --tail 10 devops-web
```

**Do not** run `docker run --name devops-web ...` again while that container name already exists; use `docker start`, remove/rename the old container, or choose another name.

---

# Module 3 — Image layers, tags, digests, and registries

## 3.1 Image layers

Dockerfiles usually create a sequence of filesystem layers. BuildKit caches build steps so unchanged work can be reused. Layers are shared where possible across images. A container adds a writable layer above the image's read-only filesystem layers.

**Crucial optimization insight:** Deleting a large file in a *later* Dockerfile layer may hide it from the final filesystem but not remove its bytes from earlier image layers. Avoid adding unnecessary files in the first place or use multi-stage builds.

## 3.2 Image naming

```text
REGISTRY/NAMESPACE/REPOSITORY:TAG

ghcr.io/uvereann/devops-cicd-lab:latest
```

- `ghcr.io`: registry.
- `uvereann`: namespace/owner.
- `devops-cicd-lab`: repository.
- `latest`: tag, **not** a guarantee of the newest version.

Other tags might include `v1.2.0`, `staging`, a build number, or a full Git commit SHA. A Git SHA tag improves traceability but is technically mutable unless registry controls prevent overwriting.

```bash
docker image ls
docker tag devops-cicd-lab:local devops-cicd-lab:v1.0.0
docker image inspect devops-cicd-lab:v1.0.0
```

`docker tag` creates another reference; it does not rebuild the image.

## 3.3 Tags versus immutable digests

A tag can move. A digest identifies content, typically an image manifest or image index. Example from this lab's successful GHCR inspection:

```text
Name:      ghcr.io/uvereann/devops-cicd-lab:latest
MediaType: application/vnd.docker.distribution.manifest.v2+json
Digest:    sha256:c7408e6cd2b0086c576fc1e64ac472a8cfd737c0694844315b7c851021e30837
```

That digest was the **observed value at inspection time**, not a promise that the current `latest` tag still points there. An immutable deployment reference has the form:

```text
ghcr.io/uvereann/devops-cicd-lab@sha256:c7408e6cd2b0086c576fc1e64ac472a8cfd737c0694844315b7c851021e30837
```

Inspect a remote image **without downloading its layers**:

```bash
docker buildx imagetools inspect ghcr.io/uvereann/devops-cicd-lab:latest
```

For multi-platform images, distinguish the **index digest** from a platform-specific **manifest digest**.

## 3.4 Private GHCR authentication

Docker Hub login does **not** authenticate you to GHCR. A private GHCR package generally requires suitable credentials and `read:packages` access. For this learning workflow, GitHub supports a personal access token (classic) with package read access; follow current GitHub guidance and organization restrictions.

**Never type the token into the quoted prompt text or as a literal shell argument.** Use a silent prompt and stdin:

```bash
read -rsp "GitHub token: " CR_PAT
echo
printf '%s' "$CR_PAT" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
unset CR_PAT
```

Then inspect:

```bash
docker buildx imagetools inspect ghcr.io/uvereann/devops-cicd-lab:latest
```

If Docker warns that credentials are stored unencrypted, configure a suitable credential helper. If a token was exposed in chat, shell history, or screenshots, **revoke/rotate it**. Never commit `~/.docker/config.json`.

**Real troubleshooting case:**

```text
failed to fetch anonymous token ... 401 Unauthorized
```

Reason: The client attempted anonymous access to a private package. Check package visibility, credentials, username, and package permissions. Another encountered error was `password is empty`: the token variable had not been populated correctly. Diagnose the input process; do not print the secret to debug it.

---

# Module 4 — Dockerfiles: build your own Express application

## 4.1 What is a Dockerfile?

A Dockerfile defines instructions for building an image. Common instructions:

| Instruction | Meaning |
|---|---|
| `FROM` | Select base image or start a new stage |
| `WORKDIR` | Set working directory for later instructions |
| `COPY` | Copy files into image |
| `ADD` | Additional copy features; prefer `COPY` for ordinary files |
| `RUN` | Execute build-time command |
| `ENV` | Set environment variable in image |
| `ARG` | Build-time variable (not a secure secret store) |
| `EXPOSE` | Document listening port; **does not publish** it |
| `USER` | Set user for later build/runtime operations |
| `CMD` | Provide default command/arguments |
| `ENTRYPOINT` | Configure the executable invoked for the container |
| `HEALTHCHECK` | Define container health test, when supported by runtime image |

**`RUN` vs `CMD`:** `RUN` executes during image build; `CMD` describes what to execute when a container starts. `ENTRYPOINT` and `CMD` interact: `CMD` often supplies arguments to an existing entrypoint.

## 4.2 Create the sample project

Use a **separate practice directory** if you don't want to change your existing repository:

```bash
mkdir -p ~/docker-practice/src ~/docker-practice/tests
cd ~/docker-practice
npm init -y
npm install express
npm install --save-dev jest supertest
npm pkg set scripts.start="node src/server.js"
npm pkg set scripts.test="jest"
```

Create `src/app.js`:

```javascript
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'DevOps CI/CD Lab', status: 'running' });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

module.exports = app;
```

Create `src/server.js`:

```javascript
const app = require('./app');
const port = Number(process.env.PORT || 3000);

// 0.0.0.0 makes the service reachable through Docker port publishing.
app.listen(port, '0.0.0.0', () => {
  console.log(`Server listening on port ${port}`);
});
```

Create `tests/app.test.js`:

```javascript
const request = require('supertest');
const app = require('../src/app');

describe('Express API', () => {
  test('GET / returns application status', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      message: 'DevOps CI/CD Lab',
      status: 'running',
    });
  });

  test('GET /health reports healthy', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('healthy');
  });
});
```

Verify **before Docker**:

```bash
npm test
npm start
# In a second terminal:
curl -i http://localhost:3000/health
```

Stop the foreground server with `Ctrl+C`.

> **Reference-project note:** The real `devops-cicd-lab` repository already contains an Express application, Jest/Supertest tests, and an `npm start` script. Its implementation can differ from the standalone teaching sample above; preserve the actual repo's existing source and tests when following the later CI/CD steps.

## 4.3 First simple Dockerfile

Create `Dockerfile.basic`:

```dockerfile
FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY src ./src
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "src/server.js"]
```

Build and run:

```bash
docker build -f Dockerfile.basic -t devops-cicd-lab:basic .
docker run -d --name docker-basic -p 3000:3000 devops-cicd-lab:basic
curl -i http://localhost:3000/
docker logs docker-basic
```

If host port 3000 is already in use, stop the conflicting container or map to `-p 3001:3000` and visit `localhost:3001`.

## 4.4 `.dockerignore`: control build context

Create `.dockerignore`:

```gitignore
node_modules
npm-debug.log*
coverage
.git
.github
.env
.env.*
!.env.example
Dockerfile.basic
README.md
```

Why? It reduces context size, avoids accidentally copying local dependencies and sensitive files, and prevents irrelevant changes from invalidating cache. Adjust exclusions if your build legitimately needs a file.

## 4.5 Layer ordering and build cache

Good pattern:

```dockerfile
COPY package*.json ./
RUN npm ci --omit=dev
COPY src ./src
```

If only `src/server.js` changes, Docker can reuse the dependency-installation layer because `package.json` and `package-lock.json` are unchanged. In contrast, `COPY . .` before `RUN npm ci` often invalidates the dependency layer on unrelated source changes.

**Interview answer:** Copy dependency manifests first to isolate infrequently changing dependencies from frequently changing source code, improving cache reuse and reducing build time.

---

# Module 5 — Multi-stage builds and distroless runtimes

## 5.1 Why multi-stage?

A builder stage may need npm, compilers, and temporary artifacts. The runtime needs only what the application uses. Multi-stage builds let us copy selected files from one stage into another.

```text
Stage 1 (builder): Node + npm -> install production dependencies
                          |
                          | COPY --from=builder
                          v
Stage 2 (runtime): minimal Node runtime + app + production deps
```

## 5.2 Our actual production Dockerfile

The reference project successfully used:

```dockerfile
# Stage 1: Install production dependencies
FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# Stage 2: Minimal production runtime
FROM gcr.io/distroless/nodejs24-debian13:nonroot AS runtime
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder --chown=nonroot:nonroot /app/node_modules ./node_modules
COPY --chown=nonroot:nonroot src ./src
EXPOSE 3000
CMD ["src/server.js"]
```

**Explain each line:**

1. `FROM node:24-alpine AS builder` creates a named stage with Node and npm.
2. `WORKDIR /app` sets a predictable location.
3. `COPY package*.json ./` copies dependency manifests first for caching.
4. `npm ci --omit=dev` installs locked production dependencies, excluding dev dependencies from disk.
5. `FROM ...:nonroot AS runtime` starts a separate minimal runtime with a non-root user.
6. `ENV NODE_ENV=production` selects production behavior for Node/Express libraries.
7. `COPY --from=builder ... node_modules` copies production dependencies without the builder's global npm installation.
8. `COPY ... src` copies application code and sets ownership.
9. `EXPOSE 3000` documents the expected listening port.
10. `CMD ["src/server.js"]` supplies the script argument to the distroless Node entrypoint; **do not write `node` again** in this image's `CMD`.

**Compatibility warning:** Alpine uses musl libc while Debian uses glibc. Copying native Node modules from an Alpine builder into a Debian runtime can fail. Our Express lab uses pure JavaScript dependencies, but applications with native addons should build dependencies in an ABI-compatible stage (for example, a Debian-based Node builder) or use an appropriate build process.

## 5.3 Why distroless?

Distroless images omit many general-purpose tools, including a normal shell and package manager. This can reduce unnecessary runtime packages and the vulnerability surface.

**Expected behavior:**

```bash
docker exec -it devops-web sh
# Likely fails: executable 'sh' not found.
```

This is not automatically a broken container. Use `docker logs`, `docker inspect`, `docker stats`, and external diagnostic tooling. **Health checks that call `curl`, `wget`, or `sh` inside this image will also fail.**

## 5.4 The real Trivy finding that motivated the change

The original `node:24-alpine` runtime image contained **seven HIGH findings** associated with npm's bundled dependency tree, including packages such as `brace-expansion`, `ip-address`, `tar`, and `undici`. The application-level production dependency audit had passed, but the image scanner inspected additional contents.

**Lessons:**

- `npm audit --omit=dev` checks the project's production npm dependency graph.
- Trivy image scanning can detect OS and language packages present anywhere in the image, including bundled tools.
- A separate distroless runtime can avoid carrying unnecessary build-time tools into production.
- A passing scan is not a guarantee of zero vulnerabilities; keep dependencies and base images updated.
- Deleting npm from a later layer of the *same stage* does not necessarily eliminate its bytes from earlier layers.

---

# Module 6 — Container networking, ports, and DNS

## 6.1 Host ports versus container ports

```text
Browser on Ubuntu: localhost:3001
               |
               | docker -p 3001:3000
               v
Container network namespace: app listening on :3000
```

Example:

```bash
docker run -d --name devops-second -p 3001:3000 devops-cicd-lab:basic
curl -i http://localhost:3001/health
```

Two containers can both listen on **internal** port 3000 because their network namespaces are separate. Their **host** port bindings must not conflict for the same host address.

`EXPOSE 3000` in a Dockerfile is documentation, not port publication. `-p 3001:3000` publishes the port. To bind only to the host loopback interface for local testing, use:

```bash
docker run -d --name local-only -p 127.0.0.1:3002:3000 devops-cicd-lab:basic
```

**Troubleshooting:** If the application binds only to `127.0.0.1` *inside the container*, published ports may not reach it. Our sample binds to `0.0.0.0`.

## 6.2 Bridge networks and service discovery

Containers on the same **user-defined bridge network** can resolve each other by container name or network alias. This is why Compose services can often communicate using service names.

```bash
docker network ls
docker network inspect bridge
```

Optional network lab (requires a locally available compatible image):

```bash
docker network create devops-net
docker network ls
# Start your app on that network:
docker run -d --name network-app --network devops-net devops-cicd-lab:basic
```

Avoid assuming `localhost` inside one container refers to another container: it refers to the **same container's** loopback interface. In Compose, use `http://app:3000`, not `http://localhost:3000`, from the Nginx service.

## 6.3 Troubleshooting a browser connection

```bash
docker ps -a
docker port devops-web
docker logs --tail 50 devops-web
curl -i http://localhost:3000/health
docker inspect devops-web --format '{{json .NetworkSettings.Ports}}'
```

Ask: Is the process running? Is it listening on the expected port and interface? Is the host port published? Is a firewall, proxy, or cloud security group blocking access? Is the health endpoint actually healthy?

---

# Module 7 — Persistent storage: volumes and bind mounts

## 7.1 Why persistence matters

A container has a writable layer, but removing the container removes that layer. Persistent databases, uploads, and other important state should live outside it.

| Storage | Description | Common use |
|---|---|---|
| Writable container layer | Tied to container lifecycle | Temporary application changes |
| Named volume | Managed by Docker; persists independently | Database data, durable application state |
| Bind mount | Maps explicit host path | Local development, configuration files |
| tmpfs mount | Memory-backed, ephemeral | Temporary sensitive or high-speed scratch data |

## 7.2 Named-volume exercise

The following example uses `busybox`, which may require downloading an image. Skip it if conserving disk space, or reuse an image that has a suitable shell.

```bash
docker volume create devops-data
docker volume ls
docker volume inspect devops-data
```

Optional demonstration:

```bash
docker run --rm -v devops-data:/data busybox sh -c 'echo hello > /data/message.txt'
docker run --rm -v devops-data:/data busybox cat /data/message.txt
```

The second container reads data written by the first, demonstrating that the volume persists independently.

## 7.3 Bind mount exercise

```bash
mkdir -p ~/docker-bind-demo
printf 'Hello from host\n' > ~/docker-bind-demo/message.txt
```

Optional, with `busybox` available:

```bash
docker run --rm \
  --mount type=bind,src="$HOME/docker-bind-demo",dst=/data,readonly \
  busybox cat /data/message.txt
```

Changes to a bind-mounted host file can be visible in the container. Read-only mounts reduce accidental modification.

**Safety:** `docker compose down -v`, `docker volume rm`, and volume-pruning commands can destroy persistent data. Always inspect volumes before removing them. A volume is not a substitute for backups.

### Interview questions

- **Volume vs bind mount?** Docker manages a named volume; a bind mount points to a host path.
- **Does `docker stop` delete volume data?** No.
- **Does removing a container automatically delete a named volume?** Not normally; beware explicit volume deletion and cleanup flags.

---

# Module 8 — Docker Compose: multi-container applications

## 8.1 Why Compose?

A real application may need an API, reverse proxy, database, and monitoring service. Compose defines these as services in one YAML file and manages their networks and volumes.

```text
Browser -> localhost:8080 -> Nginx (proxy) -> app:3000 (Express)
                                          Compose network DNS
```

## 8.2 Example `compose.yaml`

The following example is **compatible with our distroless runtime** because the application health check invokes the Node executable directly, without requiring `sh`, `curl`, or `wget`:

```yaml
services:
  app:
    build:
      context: .
    image: devops-cicd-lab:compose
    environment:
      NODE_ENV: production
    expose:
      - "3000"
    healthcheck:
      test:
        - CMD
        - /nodejs/bin/node
        - -e
        - "require('http').get('http://127.0.0.1:3000/health', r => { r.resume(); process.exit(r.statusCode === 200 ? 0 : 1); }).on('error', () => process.exit(1))"
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 10s

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      app:
        condition: service_healthy
```

**Note:** The `/nodejs/bin/node` executable path is specific to the chosen distroless Node image family and should be verified for the exact tag in use. If your image has a different path, adjust the healthcheck. Alternatively, perform the health check externally. This Compose example requires the accompanying `nginx.conf` file below.

Create `nginx.conf`:

```nginx
server {
    listen 80;
    location / {
        proxy_pass http://app:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Explain the important pieces:

- `services`: definitions of containers managed together.
- `build.context`: directory containing Docker build context.
- `image`: tag assigned to the built app image.
- `expose`: describes a port for other services; does **not** publish it to the host.
- `ports`: publishes Nginx port 80 as host port 8080.
- `volumes`: bind-mounts Nginx configuration read-only.
- `depends_on: condition: service_healthy`: delays Nginx startup until the app's health check passes; it does not guarantee permanent availability or eliminate the need for retry logic.
- `app`: DNS hostname resolved on the Compose network.

**Note for existing repo:** If your current `compose.yaml` uses `wget` or `curl` for the app healthcheck, it must be revised when running the distroless image. This example shows one solution; do not silently assume the old Compose file still works.

## 8.3 Compose commands

```bash
docker compose config               # Validate merged Compose configuration
docker compose up -d --build         # Build/start in background
docker compose ps                    # Inspect services
docker compose logs --tail 50 app    # Application logs
docker compose logs --tail 50 nginx  # Proxy logs
curl -i http://localhost:8080/health
docker compose down                  # Stop/remove Compose containers/networks
```

Use `docker compose down -v` **only if you intend to remove Compose-managed volumes**; this can delete persistent data.

### Troubleshooting lab: break/fix a proxy

**Scenario:** `curl http://localhost:8080/health` fails.

1. Run `docker compose ps` and check app health.
2. Run `docker compose logs app` and `docker compose logs nginx`.
3. Confirm Nginx targets `http://app:3000`, not `localhost:3000`.
4. Confirm the app listens on `0.0.0.0:3000`.
5. Check the healthcheck executable exists in the runtime image.
6. Validate config with `docker compose config`.

---

# Module 9 — CI/CD: test, build, scan, publish

## 9.1 Why Docker belongs in CI/CD

A CI/CD pipeline creates a repeatable, traceable artifact from source code and checks it before publication. Our lab uses:

```text
Git push / Pull request
         |
         v
Checkout -> npm ci -> Jest tests -> npm audit (production deps)
         |
         v
Buildx: Docker image build
         |
         v
Trivy: HIGH/CRITICAL vulnerability gate
         |
         v
Push to main? -> Authenticate to GHCR -> Tag and publish image
         |
         v
Server/cloud runtime later pulls and runs image (deployment is a separate step)
```

**Important:** Publishing to GHCR is not the same as automatically deploying to a server. Our workflow publishes an image; an additional deployment stage would be required for full CD to a runtime.

## 9.2 Example `.github/workflows/docker.yml`

This is a **teaching template** matching the lab's architecture. Compare it with your existing workflow rather than replacing working files blindly. It uses GitHub-hosted Ubuntu runners, Node 24, Buildx, Trivy, and GHCR.

```yaml
name: Docker CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read
  packages: write

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '24'
          cache: npm
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test
      - name: Audit production dependencies
        run: npm audit --omit=dev --audit-level=high

  docker:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      - name: Build image for scanning
        uses: docker/build-push-action@v6
        with:
          context: .
          push: false
          load: true
          tags: devops-cicd-lab:ci
          cache-from: type=gha
          cache-to: type=gha,mode=max
      - name: Scan Docker image with Trivy
        uses: aquasecurity/trivy-action@v0.36.0
        with:
          image-ref: devops-cicd-lab:ci
          exit-code: '1'
          severity: CRITICAL,HIGH
          ignore-unfixed: true
      - name: Log in to GHCR
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - name: Publish image to GHCR
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        env:
          IMAGE_REPO: ${{ github.repository }}
          COMMIT_SHA: ${{ github.sha }}
        run: |
          IMAGE="ghcr.io/${IMAGE_REPO,,}"
          docker tag devops-cicd-lab:ci "$IMAGE:$COMMIT_SHA"
          docker tag devops-cicd-lab:ci "$IMAGE:latest"
          docker push "$IMAGE:$COMMIT_SHA"
          docker push "$IMAGE:latest"
```

**Production note:** For stricter supply-chain security, pin GitHub Actions to reviewed commit SHAs, use least-privilege job permissions, and consider attestations/signatures. The version tags above are readable for a learning exercise and should be periodically updated.

## 9.3 Explain the workflow step by step

1. `on: push` and `pull_request`: run checks on changes.
2. `permissions`: permit source checkout and package publication; minimize permissions per job where possible.
3. `needs: test`: only build/scan after tests pass.
4. `npm ci`: install exactly from lockfile.
5. `npm test`: run Jest/Supertest checks.
6. `npm audit --omit=dev`: check production dependency advisories.
7. `setup-buildx-action`: initialize modern builder.
8. `build-push-action` with `load: true`: load built image into runner's local Docker image store for Trivy.
9. `cache-from`/`cache-to` with `type=gha`: restore/save BuildKit cache across runs, when available.
10. Trivy `exit-code: '1'`: fail the job on qualifying findings.
11. `login-action`: use short-lived GitHub Actions credentials to authenticate to GHCR.
12. Tag with full commit SHA and `latest`; publish only from `main` push.

## 9.4 GitHub Actions cache: what changes?

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

- `cache-from`: attempts to restore previous build layers.
- `cache-to`: exports reusable cache; `mode=max` includes intermediate build-stage cache.
- First run may be slower; later runs can reuse unchanged layers.
- Cache is an **optimization**, not a correctness or security guarantee. Cache storage, eviction, and branch-scoping behavior can affect hits.

## 9.5 Troubleshooting from the real project

### Problem A: Git push rejected

A remote pull request was merged, so the remote `main` had commits absent locally.

```bash
git fetch origin
git status
git pull --rebase origin main
# Resolve conflicts if prompted, then:
git push origin main
```

Do not force-push shared `main` to bypass the problem.

### Problem B: GitHub Action version not found

A Trivy action version reference was unavailable. The workflow was corrected to `aquasecurity/trivy-action@v0.36.0`. Always verify that a referenced action tag or commit exists.

### Problem C: Trivy finds vulnerabilities after npm audit passes

The original Node Alpine runtime carried bundled npm dependencies that the app-only audit did not cover. Solution: inspect the affected packages and use a separate minimal runtime stage rather than hiding or disabling the scan. The distroless runtime passed the lab's configured gate.

### Problem D: Private GHCR image returns 401

Authenticate to `ghcr.io` with appropriate package access; Docker Hub authentication is unrelated.

### Problem E: The browser displays JSON instead of a UI

This is expected for an API endpoint returning JSON. Verify `/` and `/health`; build a frontend separately if the project needs a visual webpage.

---

# Module 10 — Resource management and restart behavior

## 10.1 Monitor resources

```bash
docker stats --no-stream
```

Observed lab snapshot:

```text
NAME         CPU %   MEM USAGE / LIMIT    MEM %   NET I/O         BLOCK I/O    PIDS
devops-web   0.00%   20.09MiB / 7.64GiB   0.26%   11kB / 2.17kB   63MB / 0B    7
```

Interpretation:

- `CPU %`: sampled CPU usage.
- `MEM USAGE / LIMIT`: current accounted memory and reported limit.
- `MEM %`: usage relative to that limit.
- `NET I/O`: received/sent bytes.
- `BLOCK I/O`: read/write bytes.
- `PIDS`: process/thread count as reported by Docker.

A low-memory snapshot is not proof that the application will remain low-memory under load.

## 10.2 Inspect configured limits

```bash
docker inspect devops-web --format \
'Memory={{.HostConfig.Memory}} MemorySwap={{.HostConfig.MemorySwap}} NanoCPUs={{.HostConfig.NanoCpus}}'
```

Actual lab output:

```text
Memory=0 MemorySwap=0 NanoCPUs=0
```

These zeros mean no explicit limits were set through those fields. Docker can still report a host-derived memory ceiling in `docker stats`.

## 10.3 Start a constrained container

```bash
docker run -d \
  --name devops-limited \
  --memory=256m \
  --cpus=0.5 \
  --restart unless-stopped \
  -p 3001:3000 \
  ghcr.io/uvereann/devops-cicd-lab:latest
```

- `--memory=256m`: 256 MiB memory limit.
- `--cpus=0.5`: maximum CPU time equivalent to half a CPU core; not a reservation.
- `--restart unless-stopped`: restart policy for eligible stops/restarts unless deliberately stopped.
- `-p 3001:3000`: avoid conflicting with original container's host port 3000.

Verify:

```bash
docker stats --no-stream
docker inspect devops-limited --format \
'Memory={{.HostConfig.Memory}} MemorySwap={{.HostConfig.MemorySwap}} NanoCPUs={{.HostConfig.NanoCpus}} Restart={{.HostConfig.RestartPolicy.Name}}'
curl -i http://localhost:3001/health
```

Typical settings might appear as:

```text
Memory=268435456 MemorySwap=536870912 NanoCPUs=500000000 Restart=unless-stopped
```

Swap behavior depends on daemon, host, and cgroup support. `--memory-swap` is a **combined memory+swap** setting, not a standalone swap-size setting.

## 10.4 Out-of-memory troubleshooting

```bash
docker inspect devops-limited --format \
'Status={{.State.Status}} ExitCode={{.State.ExitCode}} OOMKilled={{.State.OOMKilled}}'
docker logs --tail 100 devops-limited
docker stats --no-stream
```

`ExitCode=137` can indicate a SIGKILL (including OOM termination), but is **not sufficient proof**. Correlate with `OOMKilled`, kernel/system logs, and monitoring. Investigate memory leaks, workload spikes, limits, and traffic before simply increasing memory.

## 10.5 Restart policies

| Policy | Behavior |
|---|---|
| `no` | No automatic restart |
| `on-failure` | Restart on non-zero exit, optionally with retry limit |
| `always` | Restart when eligible, including daemon restart behavior |
| `unless-stopped` | Restart unless deliberately stopped |

A restart policy can improve recovery but **cannot repair** a repeatedly failing application. Avoid creating an infinite crash loop without investigating logs.

---

# Module 11 — Docker security and production hardening

## 11.1 Defense in depth

Security is not one setting. Protect:

1. Source code and dependencies.
2. Base images and build supply chain.
3. Runtime privileges and filesystem.
4. Secrets and networking.
5. Host operating system, Docker daemon, and registry permissions.

Containers share a kernel; isolation is not absolute.

## 11.2 Run as non-root

Our runtime uses `gcr.io/distroless/nodejs24-debian13:nonroot`.

```bash
docker inspect devops-web --format '{{.Config.User}}'
```

Running as non-root limits some consequences of application compromise, but does not replace other security controls.

## 11.3 Avoid secrets in Dockerfiles and images

**Bad:**

```dockerfile
ENV DB_PASSWORD=hardcoded-password
```

**Better:** Supply secrets through an appropriate runtime secret-management mechanism. For local development, an `--env-file` may be convenient, but environment variables can still be exposed through privileged inspection and process environments.

```bash
# Example only; never commit .env containing secrets.
docker run --env-file .env my-app:latest
```

Use AWS Secrets Manager, Google Cloud Secret Manager, or platform-specific secret delivery for production, with scoped access and rotation. Add `.env` to `.gitignore` and `.dockerignore`.

## 11.4 Limit capabilities and privilege escalation

```bash
docker run -d \
  --name hardened-app \
  --cap-drop=ALL \
  --security-opt no-new-privileges \
  -p 3002:3000 \
  ghcr.io/uvereann/devops-cicd-lab:latest
```

`--cap-drop=ALL` removes granted Linux capabilities; `no-new-privileges` prevents gaining privileges via mechanisms such as setuid. Test compatibility: some workloads need selected capabilities.

Avoid `--privileged` unless there is a thoroughly justified requirement: it grants broad access to host facilities.

## 11.5 Read-only root filesystem

```bash
docker run -d \
  --name readonly-app \
  --read-only \
  --cap-drop=ALL \
  --security-opt no-new-privileges \
  -p 3003:3000 \
  ghcr.io/uvereann/devops-cicd-lab:latest
```

This prevents writing to the container's root filesystem. Applications that need temporary or persistent writable directories must be given explicit writable mounts, such as a suitable `--tmpfs` or volume, after testing.

## 11.6 Production checklist

- [ ] Trusted, maintained base image.
- [ ] Reproducible dependency installation (`npm ci` + lockfile).
- [ ] Multi-stage build and minimal runtime.
- [ ] Non-root runtime user.
- [ ] No secrets baked into image or Git.
- [ ] Image and dependency vulnerability scanning.
- [ ] Appropriate CPU/memory limits and monitoring.
- [ ] Only necessary ports published.
- [ ] Unnecessary capabilities dropped; avoid privileged mode.
- [ ] Read-only filesystem where compatible.
- [ ] Versioned image tags and/or immutable digest deployment.
- [ ] Documented startup, health checks, logging, and rollback plan.
- [ ] Host/runtime patched; registry access controlled.

**Interview scenario:** A container runs as root, has unlimited resources, hardcoded DB credentials, and uses `--privileged`. Recommend non-root execution, limits, secure runtime secrets with credential rotation, removal of privileged mode, least-privilege capabilities, scanning, and host hardening.

---

# Module 12 — Systematic Docker troubleshooting

## 12.1 The five-step diagnostic sequence

```text
1. STATUS       docker ps -a
2. LOGS         docker logs --tail 100 <container>
3. CONFIG       docker inspect <container>
4. RESOURCES    docker stats --no-stream
5. CONNECTIVITY docker port <container> + curl -i <endpoint>
```

Always start by **observing**. Avoid deleting or rebuilding a production container before preserving evidence and understanding the cause.

## 12.2 Useful inspection commands

```bash
docker ps -a
docker logs --tail 50 devops-web
docker logs -f devops-web       # Ctrl+C stops following, not the container
docker port devops-web
docker stats --no-stream
docker inspect devops-web --format \
'Status={{.State.Status}} ExitCode={{.State.ExitCode}} OOMKilled={{.State.OOMKilled}}'
curl -i http://localhost:3000/health
```

## 12.3 Failure scenarios and remedies

| Symptom | Check | Typical cause / next step |
|---|---|---|
| `Exited (1)` | `docker logs`, startup command | Application error, missing env/config, invalid command |
| Browser connection refused | `docker ps`, `docker port`, `curl` | Wrong host port, process not listening, app crash |
| Container running but endpoint fails | `curl /health`, app logs | Application unhealthy despite live process |
| `bind: address already in use` | `docker ps`, host listeners | Host port conflict; choose another host port |
| `401 Unauthorized` from GHCR | Registry login and package access | Private image needs authorized credentials |
| `docker exec ... sh` fails | Check runtime image | Distroless has no shell |
| Healthcheck fails | `docker inspect`, healthcheck command | `curl`/`wget` absent or endpoint failing |
| `Exited (137)` | `OOMKilled`, logs, metrics | Possible OOM or other SIGKILL; verify |
| Permission denied writing file | UID/GID, mount permissions | Non-root user cannot write mounted path |
| Build fails at `npm ci` | Lockfile, npm output | Missing/inconsistent `package-lock.json` |
| Compose proxy fails | Compose logs, service DNS | Wrong hostname/port, unhealthy app |
| Git push rejected | `git fetch`, `git status` | Remote branch advanced; rebase/merge safely |

## 12.4 Practice diagnosing without damaging data

**Scenario A:** `docker ps` shows `Up`, but browser fails.

- Check published ports: `docker port <name>`.
- Test host endpoint with `curl`.
- Inspect application logs and the listening interface.
- If remote, check firewall/security group/proxy.

**Scenario B:** Compose app is unhealthy after switching to distroless.

- Inspect the healthcheck command.
- Does it invoke `/bin/sh`, `curl`, or `wget`? Those are generally absent.
- Replace it with a compatible executable or external probe.
- Verify `/health` works independently.

**Scenario C:** Image security scan fails despite `npm audit` success.

- Read exact Trivy findings and package paths.
- Distinguish application dependencies from bundled runtime tools.
- Update or redesign the runtime image; do not disable security checks just to make CI green.

---

# Module 13 — Docker disk usage and safe cleanup

Especially important on laptops with limited storage.

```bash
docker system df
docker image ls
docker ps -a
docker volume ls
```

**Targeted cleanup:**

```bash
docker stop devops-limited
docker rm devops-limited
# Remove only an image tag you know is no longer needed:
docker rmi devops-cicd-lab:v1.0.0
```

A tag can be removed without deleting shared underlying layers if other references still use them.

**Use caution:**

- `docker image prune` removes dangling images.
- `docker image prune -a` can remove images not referenced by containers, even if you intend to use them later.
- `docker builder prune` removes build cache and can slow later builds.
- `docker system prune` removes multiple categories of unused Docker resources.
- `docker system prune --volumes` can remove unused volumes and **permanently delete data**. Do not use casually.

Inspect before cleanup. Prefer removing known practice containers/images over broad pruning.

---

# Module 14 — Final practical assessment (with model answers)

Try answering each question **before** reading its answer. Commands are examples; don't run commands that conflict with containers you already have.

## Challenge 1 — Image vs container

**Scenario:** Run `ghcr.io/uvereann/devops-cicd-lab:latest` on an Ubuntu server.

**Q1. Image vs container?**  
**Answer:** An image is a packaged read-only template; a container is an instance created from the image, with its own runtime state and writable layer.

**Q2. Pull?**

```bash
docker pull ghcr.io/uvereann/devops-cicd-lab:latest
```

**Q3. Run in background on host port 3000?**

```bash
docker run -d --name devops-web -p 3000:3000 ghcr.io/uvereann/devops-cicd-lab:latest
```

Private GHCR requires appropriate authentication.

## Challenge 2 — Dockerfile and multi-stage builds

**Q1. What is a Dockerfile?** A recipe for constructing an image.

**Q2. Why multi-stage?** Separate build-time tools from the final runtime, reducing unnecessary files and packages.

**Q3. `COPY` vs `COPY --from=builder`?** Ordinary `COPY` takes files from build context; `COPY --from` takes files from another build stage.

## Challenge 3 — Networking

**Q1. `-p 3001:3000`?** Host port 3001 forwards to container port 3000.

**Q2. Can two containers listen internally on 3000?** Yes; their network namespaces are separate.

**Q3. Why can localhost:3001 fail even if container is Up?** Wrong port mapping, application listening on wrong interface, unhealthy app, or networking/firewall issue. Check ports, logs, and `curl`.

## Challenge 4 — Volumes

**Q1. Why not store database data only in container writable layer?** It disappears when the container is removed.

**Q2. Named volume vs bind mount?** Docker-managed storage vs explicit host directory mapping.

**Q3. Example named volume?**

```bash
docker volume create app-data
# Illustrative; requires the busybox image:
docker run -d --name data-demo -v app-data:/data busybox sleep 3600
```

## Challenge 5 — Docker Compose

**Q1. What problem does Compose solve?** Declares and manages multi-service container applications in YAML.

**Q2. How does Nginx contact the Express app?** Use service DNS such as `http://app:3000` on the shared Compose network.

**Q3. Start/stop?**

```bash
docker compose up -d --build
docker compose down
```

## Challenge 6 — CI/CD, GHCR, and security

**Q1. Explain pipeline.** Checkout → npm install/tests/audit → Buildx image build → Trivy scan → authenticate and publish successful `main` builds to GHCR.

**Q2. Why Trivy after npm audit?** They inspect different scopes; Trivy can identify vulnerabilities in packages included in the runtime image beyond app dependencies.

**Q3. Tag vs digest?** A tag is a mutable human-readable reference; a digest identifies image manifest content.

## Challenge 7 — Troubleshooting and resource limits

**Q1. First diagnostic sequence?** `docker ps -a` → `docker logs` → `docker inspect` → `docker stats` → `docker port`/`curl`.

**Q2. OOM investigation?** Check memory usage, configured limits, `OOMKilled`, exit code, app/kernel logs, and traffic. Exit code 137 alone is not proof.

**Q3. Hardening recommendations?** Non-root, minimal image, no embedded secrets, least-privilege capabilities, no unnecessary privileged mode, CPU/memory limits, read-only filesystem where appropriate, vulnerability scanning, controlled registry access.

---

# Module 15 — Additional interview drill (20 questions)

1. **What is Docker?** A platform for packaging, distributing, and running containerized applications.
2. **Image vs container?** Template versus instance.
3. **Container vs VM?** Shared host kernel versus guest OS/kernel.
4. **`docker run` vs `docker start`?** New container versus existing container.
5. **`RUN` vs `CMD`?** Build-time instruction versus runtime default command/arguments.
6. **`CMD` vs `ENTRYPOINT`?** Default command/arguments versus configured executable.
7. **`EXPOSE` vs `-p`?** Documentation versus publishing host port.
8. **Why `.dockerignore`?** Smaller context, fewer accidental inclusions, better caching.
9. **Why copy package files before source?** Cache dependency installation independently.
10. **Why multi-stage builds?** Keep build tools out of final runtime.
11. **Why use non-root?** Reduce unnecessary privileges.
12. **What is distroless?** Minimal runtime image without typical OS utilities.
13. **Why might `docker exec ... sh` fail?** No shell in distroless image.
14. **What is a named volume?** Docker-managed persistent storage.
15. **How do Compose services find each other?** DNS service names on shared networks.
16. **Why is `localhost` wrong for another container?** It points to the current container.
17. **Tag vs digest?** Mutable reference versus content identifier.
18. **Why do security scanning in CI?** Catch known vulnerabilities before publication/deployment.
19. **How do you debug an OOM?** Inspect resource metrics, limits, kill state, and logs.
20. **Does GHCR publishing deploy the app?** No; a runtime still needs to pull/run it.

---

# Module 16 — Capstone lab: complete Docker workflow

**Goal:** Demonstrate the end-to-end path without assuming automatic cloud deployment.

### Step 1 — Verify application

```bash
npm ci
npm test
npm audit --omit=dev --audit-level=high
```

### Step 2 — Build image

```bash
docker build -t devops-cicd-lab:local .
```

### Step 3 — Run and inspect

```bash
docker run -d --name capstone-app -p 3004:3000 devops-cicd-lab:local
docker ps
docker logs --tail 20 capstone-app
curl -i http://localhost:3004/health
docker inspect capstone-app --format 'User={{.Config.User}} Status={{.State.Status}}'
```

### Step 4 — Understand networking and resource usage

```bash
docker port capstone-app
docker stats --no-stream
docker inspect capstone-app --format \
'Memory={{.HostConfig.Memory}} NanoCPUs={{.HostConfig.NanoCpus}}'
```

### Step 5 — Verify GitHub Actions and registry

- Push code through the normal Git workflow.
- Confirm tests, audit, image build, and Trivy scan pass.
- Confirm GHCR package appears with `latest` and Git SHA tags.
- Inspect the remote digest using `docker buildx imagetools inspect` after authentication if private.
- Explain why the published image is not yet an automatic server deployment.

### Step 6 — Clean up **only the capstone container**

```bash
docker stop capstone-app
docker rm capstone-app
```

### Capstone acceptance checklist

- [ ] I can explain the Dockerfile line by line.
- [ ] Tests pass locally.
- [ ] Docker image builds.
- [ ] Application responds on the published host port.
- [ ] I can read logs and inspect container state.
- [ ] I understand image tags and digests.
- [ ] I can explain our Trivy security gate.
- [ ] I can explain what GHCR does and does not do.
- [ ] I can troubleshoot an unhealthy or inaccessible container.
- [ ] I can clean up practice resources without deleting valuable volumes.

---

# Quick-reference command sheet

```bash
# Images
docker image ls
docker pull IMAGE
docker build -t IMAGE:TAG .
docker image inspect IMAGE:TAG
docker tag SOURCE:TAG TARGET:TAG
docker buildx imagetools inspect REGISTRY/IMAGE:TAG

# Containers
docker ps -a
docker run -d --name NAME -p 3000:3000 IMAGE:TAG
docker start NAME
docker stop NAME
docker rm NAME
docker logs --tail 50 NAME
docker inspect NAME
docker port NAME
docker stats --no-stream

# Networks / storage
docker network ls
docker network inspect NETWORK
docker volume ls
docker volume inspect VOLUME

# Compose
docker compose config
docker compose up -d --build
docker compose ps
docker compose logs --tail 50
docker compose down

# Diagnostics / disk
docker system df
docker inspect NAME --format '{{.State.Status}}'
docker inspect NAME --format '{{.State.OOMKilled}}'
curl -i http://localhost:3000/health
```

---

# Common mistakes to avoid

1. Assuming `latest` means newest or immutable.
2. Assuming a registry push is the same as deployment.
3. Confusing `EXPOSE` with publishing a port.
4. Using `localhost` to reach another container on a bridge network.
5. Copying `node_modules` from the host into a Linux container without considering compatibility.
6. Running `npm install` without a reproducible lockfile in CI when `npm ci` is appropriate.
7. Placing source code before dependency installation in a way that defeats caching.
8. Assuming distroless images contain a shell, `curl`, or `wget`.
9. Assuming an Alpine-built native addon always works in a Debian runtime.
10. Hardcoding secrets in a Dockerfile or committing `.env`.
11. Using `--privileged` to work around permission errors without diagnosis.
12. Treating a running container as proof the app is healthy.
13. Treating exit code 137 as definitive OOM proof.
14. Running broad prune commands without checking data/volumes.
15. Assuming Docker Hub authentication also covers GHCR.
16. Disabling security scans instead of investigating vulnerabilities.

---

# Recommended next step — Day 04: Kubernetes

Docker taught us how to **package and run one or more containers**. Kubernetes extends the operational model to scheduling, self-healing, scaling, service discovery, configuration, rolling updates, and workload management across a cluster.

Before starting Kubernetes, be able to answer:

- What exactly is the container image Kubernetes runs?
- How do containers communicate and expose services?
- Where does persistent data live?
- How are CPU and memory limits expressed and monitored?
- How do you know an application is healthy?
- How does CI produce a trustworthy image for deployment?

**You are ready to progress when you can explain and demonstrate those concepts, not merely memorize commands.**

---

## References for further study

- Docker documentation: https://docs.docker.com/
- Dockerfile reference: https://docs.docker.com/reference/dockerfile/
- Docker Compose: https://docs.docker.com/compose/
- Docker networking: https://docs.docker.com/engine/network/
- Docker storage: https://docs.docker.com/engine/storage/
- Docker resource constraints: https://docs.docker.com/engine/containers/resource_constraints/
- GitHub Container Registry: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
- GitHub Actions: https://docs.github.com/en/actions
- Trivy: https://trivy.dev/

---

**End of Day 03 — Docker.** Return to any module when a real-world problem arises. The best Docker engineer is not the one who memorizes the most flags, but the one who can explain the system, verify assumptions, and troubleshoot confidently.
