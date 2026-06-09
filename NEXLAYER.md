# Nexlayer — Ops.Chat

<!-- nexlayer:meta version=1 analyzed=2026-06-09T03:20:42Z repo=https://github.com/bhbsoft/Ops.Chat branch=develop -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
Rocket.Chat is an open-source web-based chat platform providing real-time communication, collaboration tools, and an extensible chatbot ecosystem.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Node.js | language | unspecified | package.json |
| Meteor | framework | unspecified | package.json, .meteor |
| MongoDB | database | 3.2 | docker-compose.yml |
| Hubot | tool | latest | docker-compose.yml |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- client/ — Frontend assets and client-side logic
- server/ — Backend server logic and API handlers
- lib/ — Shared libraries and utilities
- packages/ — Modular internal packages (e.g., rocketchat-katex)
- tests/ — End-to-end and unit tests
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
Services that must be configured separately (not deployed by Nexlayer):

- SMTP Server (MAIL_URL)
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Node.js
- Meteor
- MongoDB

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
PORT=3000
ROOT_URL=http://localhost:3000
MONGO_URL=mongodb://localhost:27017/rocketchat
MONGO_OPLOG_URL=mongodb://localhost:27017/local
```

### Steps

1. `npm install` — Install base dependencies
2. `meteor npm i` — Install meteor-specific dependencies
3. `meteor` — Start the Rocket.Chat application

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `app` | `ROOT_URL` | `"<% URL %>"` | plain |
| `app` | `MONGO_URL` | `"mongodb://${mongo:27017}/rocketchat"` | inter-pod |
| `app` | `MONGO_OPLOG_URL` | `"mongodb://${mongo:27017}/local?replicaSet=rs0"` | inter-pod |
| `app` | `PORT` | `"3000"` | plain |
| `app` | `NODE_OPTIONS` | `"--max-old-space-size=900"` | plain |
| `mongo` | `command` | `"mongod --replSet rs0 --bind_ip_all"` | plain |

### nexlayer.yaml

```yaml
application:
  name: rich-nova-ops.chat
  pods:
    - name: app
      image: "# filled by pipeline"
      path: /
      servicePorts:
        - 3000
      vars:
        ROOT_URL: "<% URL %>"
        MONGO_URL: "mongodb://${mongo:27017}/rocketchat"
        MONGO_OPLOG_URL: "mongodb://${mongo:27017}/local?replicaSet=rs0"
        PORT: "3000"
        NODE_OPTIONS: "--max-old-space-size=900"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      command: "mongod --replSet rs0 --bind_ip_all"
      vars: {}
```

<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| mongo | mirror.gcr.io/library/mongo:3.2 | 27017 | database |
| rocketchat | mirror.gcr.io/library/node:14-alpine | 3000 | web |
| hubot | mirror.gcr.io/library/node:14-alpine | 3001 | worker |

### Inter-pod environment variables

- `rocketchat` pod: `MONGO_URL=mongodb://${mongo:27017}/rocketchat`
- `rocketchat` pod: `MONGO_OPLOG_URL=mongodb://${mongo:27017}/local`
- `hubot` pod: `ROCKETCHAT_URL=${rocketchat:3000}`

### Deployment notes

- MongoDB must be initialized as a replica set for the oplog to function.
- Inter-pod communication utilizes ${podName:port} syntax (e.g., ${mongo:27017}).
- The Hubot worker depends on the rocketchat web pod being available.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-09T03:22:28Z  
**Live URL:** https://awesome-moose-rich-nova-opschat.cloud.nexlayer.ai  
**Runtime:** node · **Port:** 3000  
**Deploy branch:** develop  

```yaml
application:
  name: rich-nova-ops.chat
  pods:
    - name: app
      image: "# filled by pipeline"
      path: /
      servicePorts:
        - 3000
      vars:
        ROOT_URL: "<% URL %>"
        MONGO_URL: "mongodb://${mongo:27017}/rocketchat"
        MONGO_OPLOG_URL: "mongodb://${mongo:27017}/local?replicaSet=rs0"
        PORT: "3000"
        NODE_OPTIONS: "--max-old-space-size=900"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      command: "mongod --replSet rs0 --bind_ip_all"
      vars: {}
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-09T03:20:42Z | analyzed | initial repo analysis |
| 2026-06-09T03:22:28Z | success | deployed https://awesome-moose-rich-nova-opschat.cloud.nexlayer.ai |
<!-- nexlayer:end -->
