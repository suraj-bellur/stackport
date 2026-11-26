# StackPort – Multi-Tier DevOps Lab Application

StackPort (formerly the VProfile demo) is a Spring MVC web app with web, app, cache, messaging and database tiers. It is used as a realistic target for practising provisioning, CI/CD and container workflows.

> **You are on the `containers` branch:** the whole stack runs with Docker Compose.
> Other branches cover other lab stages (see [Branches](#branches)).

---

## Architecture

| Service (compose name) | Image | Port | Role |
|---|---|---|---|
| `stackportweb` | `surajbellur/stackport-web` (Nginx) | 80 | Reverse proxy → app |
| `stackportapp` | `surajbellur/stackport-app` (Tomcat 10, JDK 21) | 8080 | Spring MVC app (`ROOT.war`) |
| `stackportdb` | `surajbellur/stackport-db` (MySQL 8.0.33) | 3306 | `accounts` database, seeded from `db_backup.sql` |
| `stackportcache01` | `memcached` | 11211 | Cache |
| `stackportmq01` | `rabbitmq` | 5672 | Message broker |

`src/main/resources/application.properties` already points at these service names.

---

## Quick start (Docker Compose)

Requires Docker with the Compose plugin.

```bash
docker compose up -d
docker compose ps
```

Open http://localhost (via Nginx) or http://localhost:8080 (Tomcat directly).
Seeded login: user `admin_vp` (password `admin_vp`, the upstream VProfile default). You can also register a new user.

Stop and clean up:

```bash
docker compose down          # keep volumes
docker compose down -v       # also delete DB/app volumes
```

### Building the images yourself

`compose.yaml` uses the pre-built images from Docker Hub by default. To build locally, uncomment the `build:` / `context:` lines for a service in `compose.yaml` and comment out its `image:` line, then:

```bash
docker compose build
docker compose up -d
```

| Dockerfile | Notes |
|---|---|
| `Docker-files/app/Dockerfile` | Multi-stage: clones **this repo's `containers` branch from GitHub** and runs `mvn install`, then copies the WAR into Tomcat. Local uncommitted changes are *not* included. |
| `Docker-files/db/Dockerfile` | MySQL 8.0.33 seeded with `Docker-files/db/db_backup.sql` |
| `Docker-files/web/Dockerfile` | Nginx with `nginstackportapp.conf` proxying to `stackportapp:8080` |

### Running inside a Vagrant VM (optional)

If Docker isn't installed on your host, use a VM:

```bash
cd vagrant/windowsAndMacIntel      # or vagrant/macosarm on Apple Silicon
vagrant up && vagrant ssh
# install Docker inside the VM, then:
cd /stackport && docker compose up -d
```

The repo root is mounted at `/stackport` in the VM. The VM's IP is `192.168.56.16`.

---

## Building the WAR without Docker

Requires JDK 17+ and Maven 3.9+.

```bash
mvn clean install            # produces target/stackport-v2.war
mvn test                     # unit tests
```

---

## CI/CD

| File | Pipeline |
|---|---|
| `Jenkinsfile` | Build → unit test → integration test → SonarQube → publish to Nexus |
| `userdata/Jenkinsfile` | Same as above, plus Docker image build → push to AWS ECR → deploy to ECS (expects Jenkins credentials `ecr:us-east-1:awscreds`) |

`ansible/` contains playbooks for setting up Tomcat and deploying the app to hosts.

---

## Branches

Each branch is one stage of the lab:

| Branch | Stage |
|---|---|
| `local` | Local VMs with Vagrant (manual and automated provisioning) |
| `aws_lift_and_shift` | EC2 instances + userdata scripts |
| `aws_refactor` | AWS managed services (RDS, ElastiCache, Amazon MQ) |
| `electron` / `atom` | Jenkins, Nexus and SonarQube CI pipeline |
| `docker` | Dockerfiles + Jenkins → ECR/ECS pipeline |
| `containers` | Full Docker Compose stack (this branch, latest) |

---

## Project layout

```
├── compose.yaml              # Docker Compose stack
├── Docker-files/             # app / db / web Dockerfiles
├── src/main/java/...         # Spring MVC app (package com.visualpathit.account)
├── src/main/resources/       # application.properties, db_backup.sql
├── src/main/webapp/          # JSP views and static resources
├── ansible/                  # Ansible playbooks and templates
├── userdata/Jenkinsfile      # Docker/ECR/ECS pipeline
├── vagrant/                  # VM to run Docker in (Win/Intel Mac, ARM Mac)
├── Jenkinsfile               # Build/test/Sonar/Nexus pipeline
└── pom.xml
```

---

## Notes

- The credentials in this repo (`admin123`, `test`, …) are lab defaults. Don't reuse them anywhere real.
- Based on the open-source VProfile project.
