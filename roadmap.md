# DevOps Learning Roadmap

All projects run on my home lab server (Ubuntu, 22 GB RAM) first. AWS is used only for short, optional "real cloud" runs (total budget $10-20).

| # | Project | Source | Status | Started | Finished | Repo |
|---|---|---|---|---|---|---|
| 1 | Jenkins + Docker CI/CD pipeline | DevOps-Project-05 | In progress | 2026-10-19 | | (to create) |
| 2 | Kubernetes end to end on k3s | DevOps-Project-08 | Not started | | | |
| 3 | Terraform + Kubernetes (Super Mario) | DevOps-Project-12 | Not started | | | |
| 4 | DevSecOps pipeline (Zomato clone) | DevOps-Project-13 | Not started | | | |
| 5 | Capstone: Ansible, artifact repo, GitHub Actions, Argo CD/Helm | DevOps-Project-06 (+18) | Not started | | | |

## Project 1 plan (home lab version)

The source project uses two AWS EC2 servers, password SSH and a Publish Over SSH job. My version keeps the same idea but runs on one home server and uses a Jenkinsfile (pipeline as code), which is closer to what companies use today.

```
GitHub repo ──(webhook/poll)──> Jenkins (on server)
                                   │ 1. Checkout code
                                   │ 2. Maven build  -> .war file
                                   │ 3. docker build -> image (Tomcat + .war)
                                   │ 4. docker run   -> container on a port
                                   ▼
                          App in browser via SSH tunnel / Tailscale
```

## Project 1 modules

Every module follows the same loop: **map** (where it sits in the pipeline) → **concept** (what and why) → **do it** (I write the commands from hints) → **verify** → **explain it back**.

| # | Module | Pipeline part | What I learn | Done when |
|---|---|---|---|---|
| 0 | Server prep | (foundation) | Linux server, Docker, firewall, ports, SSH tunnel | Docker runs, UFW only allows SSH ✅ |
| 1 | **Jenkins** | `[Jenkins]` the automation engine | What CI/CD is, why Jenkins needs Java, services (`systemctl`), safe access by SSH tunnel, setup wizard, plugins | I can log in to Jenkins from my Mac and explain how the tunnel works |
| 2 | **Git + GitHub** | `[GitHub] → Jenkins` | Repos, commits, `.gitignore`, pushing code, how Jenkins pulls code (credentials) | A Jenkins job checks out my repo |
| 3 | **Maven** | `Jenkins → [Maven] → .war` | What a build tool does, `pom.xml`, `mvn package`, what a `.war` file is | Jenkins builds a `.war` file |
| 4 | **Docker image for the app** | `.war → [Dockerfile] → image` | Tomcat, writing a Dockerfile, `docker build` / `docker run` by hand first | The app opens in the browser from a container I started by hand |
| 5 | **Jenkins pipeline** | `GitHub → Jenkins → Maven → Docker` joined | Jenkinsfile stages, the Jenkins user's Docker permission, replacing old containers | One click runs the full pipeline |
| 6 | **Automation trigger** | `git push → pipeline` | Poll SCM vs webhooks, a full CI/CD loop | A push to GitHub redeploys the app automatically |
| 7 | **Wrap-up** | the whole project | README, troubleshooting log, project summary, screenshots, interview questions | Repo is recruiter-ready |

Progress:
- [x] Module 0: Server prep
- [x] Module 1: Jenkins
- [x] Module 2: Git + GitHub
- [x] Module 3: Maven
- [x] Module 4: Docker image for the app
- [x] Module 5: Jenkins pipeline
- [x] Module 6: Automation trigger
- [ ] Module 7: Wrap-up

## Project 1 steps

**Module 1: Jenkins**
- [x] 1.1 Java 21 (Jenkins is a Java program)
- [x] 1.2 Install Jenkins and check that the service is running
- [x] 1.3 SSH tunnel from my Mac (reach Jenkins with the firewall closed)
- [x] 1.4 Unlock Jenkins (already done in earlier practice)
- [x] 1.5 Setup wizard: plugins and admin user (already done in earlier practice)
- [x] 1.6 Health check: no warnings; updated ASM API + Jackson 3 API plugins
- [x] 1.7 Hello job: runs as user `jenkins`, workspace `/var/lib/jenkins/workspace/<job>`, `docker ps` = permission denied (fix in 5.2)

**Module 2: Git + GitHub**
- [x] 2.1 GitHub repo with a `.gitignore` (Maven template)
- [x] 2.2 Generated starter web app (Maven archetype webapp: pom.xml, index.jsp, web.xml) and pushed to GitHub
- [x] 2.3 Jenkins job `module2-checkout` checks out the repo (public HTTPS, no credentials, branch main)

**Module 3: Maven**
- [x] 3.1 Concepts: build tool, `pom.xml`, `.war`
- [x] 3.2 Set up Maven in Jenkins (Maven Integration plugin, tool `maven-3`, auto-install)
- [x] 3.3 Job `module3-maven-build` ran `clean package`: target/jenkins-docker-cicd.war (1715 bytes, BUILD SUCCESS)

**Module 4: Docker image for the app**
- [x] 4.1 Plain Tomcat container by hand (skipped the browser check; the image test in 4.3 proves Tomcat works)
- [x] 4.2 Dockerfile (Tomcat + `.war`) and `docker build`: `jenkins-app:1.0` exists
- [x] 4.3 `docker run` my image on 127.0.0.1:8082; Hello World shows at `http://localhost:8082/jenkins-docker-cicd/` through the tunnel (2026-10-22)
- [x] 4.4 Cleaned up, explained Module 4 back, interview questions (2026-10-22). Gaps to revisit: build-context errors, debugging a container that exits (`docker logs`).

**Module 5: Jenkins pipeline**
- [x] 5.1 Concept: Jenkinsfile and stages
- [x] 5.2 Give the Jenkins user Docker permission
- [x] 5.3 Clean up the repo (.DS_Store) and add the Dockerfile to the repo, push
- [x] 5.4 Write the Jenkinsfile (Checkout → Build → Image → Deploy), push
- [x] 5.5 Create the Pipeline job in Jenkins (Pipeline script from SCM)
- [x] 5.6 Run it, open the app, then redeploy to test the old-container replacement (user confirmed 2026-10-23: edited index.jsp, Build Now, page and docker ps updated)
- [x] 5.7 Explained Module 5 back + interview question (2026-10-23; permission denied answer correct)

**Module 6: Automation**
- [x] 6.1 Poll SCM (no public webhook needed): trigger line in Jenkinsfile + Poll SCM ticked in UI
- [x] 6.2 Push a change and watch it auto-deploy: build log says "Started by an SCM change" (user-reported 2026-10-23)

**Module 7: Wrap-up**
- [ ] 7.1 Troubleshooting log, then project summary, README, screenshots ← current
  - Full recap of the project, every question and answer, and diagrams: [Project-1-Wrap-Up/PROJECT-1-WRAP-UP.md](Project-1-Wrap-Up/PROJECT-1-WRAP-UP.md)
- [ ] 7.2 `docs/project-summary.md` (8 sections)
- [ ] 7.3 Recruiter-friendly README and screenshots
- [ ] 7.4 Final interview question, update roadmap and Current Status
