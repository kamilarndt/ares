# Contabo Infrastructure Analysis — Existing System

## Hardware
- CPU: 6 cores
- RAM: 11GB (2.6GB used, 9.1GB available)
- Disk: 193GB (57GB used, 136GB free)
- Swap: 4GB (2.2GB used)
- GPU: NONE
- OS: Ubuntu 6.8.0-124-generic x86_64

## Running Services (15+)

### Docker Containers
| Container | Image | Purpose | Port |
|-----------|-------|---------|------|
| hermes-ubek | nousresearch/hermes-agent:latest | Hermes Agent (11 profiles) | — |
| mem0-postgres | pgvector/pgvector:pg17 | Vector memory (mem0) | 8432 |
| qdrant | qdrant/qdrant:latest | Vector database | 6333-6334 |

### PM2 Processes
| Name | Purpose | Port |
|------|---------|------|
| car-rent-app | Next.js car rental app (rent.karndt.pl) | 3003 |
| ubek-next-new | UBEK Next.js frontend | 3001 |
| ubek-agent | UBEK Python agent API | — |
| pm-bridge | PM bridge service | — |
| cloudflared | Cloudflare tunnel | — |
| mcp-v7 | MCP server | 8443 |

### Other Services
| Service | Purpose | Port |
|---------|---------|------|
| Caddy | TLS reverse proxy | 80, 443 |
| nginx | Reverse proxy | 8080-8084 |
| LightRAG | Knowledge graph server | 9621 |
| uvicorn | Python API (Honcho) | 8000 |
| llama-server | Local LLM (qwen2.5-1.5b.gguf) | — |
| node | Unknown (possibly OmniRoute) | 20129 |
| python3 | Unknown service | 8767 |

## Hermes Configuration

### Main Config (Docker /opt/hermes-ubek/data/config.yaml)
- Default model: anthropic/claude-opus-4.6 via OpenRouter
- Compression: enabled (target ratio 0.2)
- Memory: enabled (2200 char limit)
- Prompt caching: 5min TTL
- Session reset: idle 1440min, at hour 4
- Terminal: local backend, 180s timeout

### UBEK Profile (Active Orchestrator)
- Model: deepseek-v4-flash via opencode-go (FREE!)
- API: https://opencode.ai/zen/go/v1
- Toolsets: terminal, file, web, skills, kanban, memory, session_search, delegation, agency_agents
- Max turns: 120
- SOUL: "Jestes ubek — glowny orchestrator profili w systemie UBEK. Nie pracujesz bezposrednio — delegujesz do 10 specjalistycznych profili."
- Honcho integration: http://localhost:8000, workspace "ubek"
- Gateway running (gateway.pid, gateway_state.json)
- 80MB state.db (active session history)

## 11 Specialized Profiles

| Profile | Role | Key Rule |
|---------|------|----------|
| ubek | Orchestrator | NIGDY nie pisze kodu — deleguje |
| builder | Code generator | Kod > dokumentacja, działa > idealne |
| deployer | Infrastructure | Infrastructure as Code, zero-downtime |
| backend-dev | Backend code | Type safety, testy przed mergem |
| frontend-dev | Frontend code | — |
| code-developer | General coding | Czytelnosc > cleverness |
| content-creator | Documentation/content | Konkretnie, rzeczowo, po polsku |
| test-runner | Tests | — |
| web-tester | Browser tests | — |
| infra-admin | Infrastructure admin | Backup przed zmiana, least privilege |
| test-profile | Testing | — |

## Cron Jobs (3 Active)
1. **gardener-backlog-sweep** — Weekly Mon 6am, checks backlog + health
2. **health-check-hourly** — Every 60min, script-based, 69 completed runs
3. **session-cleanup-daily** — Daily 5am, script-based

## Skills (20 Categories)
apple, autonomous-ai-agents, creative, data-science, deployment, devops, email, github, hermes, hermes-memory-deployment, media, mlops, note-taking, productivity, profiles-catalog, research, smart-home, social-media, software-development, thinking

## Memory Infrastructure
- **mem0** (pgvector postgres) — agent memory
- **Qdrant** — vector database
- **LightRAG** — knowledge graph server (port 9621)
- **llama-server** — local embeddings (qwen2.5-1.5b.gguf)

## Multi-Agent Orchestration
- **Honcho** server at localhost:8000
  - PostgreSQL backend
  - Session observers (limit 10)
  - Context management (100k max tokens)
  - Message embedding enabled
  - Workspace: ubek
  - AI peer: ubek-ai

## Local WSL Profiles (for reference)
- `pm` — PM profile (github.com/kamilarndt/pm)
- `tenant-demo` — tenant demo profile
- No "belforta" profile found locally

## Car-Rent-App (Deployed)
- URL: https://rent.karndt.pl/login
- Stack: Caddy (TLS) → 127.0.0.1:3003 → Next.js 16 → PM2
- Location: /opt/projects/car-rental-app
- Features: Multi-tenant, OCR (Gemini 2.5 Flash), Prisma + SQLite
- AHE Harness initialized (4 phases: spec→build→review→verify)
- Session: 20260702_121504_309d21 (belforta profile)

## Analysis: How to Use This for Omnigent

### What's Already There (REUSE)
1. **Multi-agent orchestration** — UBEK + Honcho = orchestrator pattern (like Polly)
2. **11 specialized profiles** — map to money-earning agent roles
3. **Memory infrastructure** — mem0 + Qdrant + LightRAG = 3-layer memory
4. **Local LLM** — qwen2.5-1.5b for T1 tasks (FREE)
5. **Cron + heartbeat** — already running, add nightly self-improvement
6. **Docker isolation** — hermes-ubek container
7. **Skills** — 20 categories already installed
8. **Free model** — deepseek-v4-flash via opencode-go (FREE!)
9. **Gateway** — already running for external access
10. **MCP server** — mcp-v7 already running on port 8443

### What's Missing (ADD)
1. **Omnigent** — meta-harness with policies (cost_budget, blast_radius, spawn_bounds)
2. **Money-earning profiles** — opportunity-scout, bidder, financier, x402-seller, prediction-trader
3. **ClawRouter** — model routing with USDC payments
4. **x402 payment infrastructure** — agent wallet, USDC, payment endpoints
5. **dealwork.ai API integration** — job polling, bidding, delivery
6. **Polymarket integration** — prediction market trading
7. **Nightly self-improvement loop** — review blockers, fix permanently
8. **War room** — kill underperforming channels
9. **Soul file for money-earning mission** — "Build $10k/mo with zero human employees"

### Recommended Approach
1. Install Omnigent INSIDE the existing hermes-ubek container
2. Add money-earning profiles alongside existing UBEK profiles
3. Use UBEK as meta-orchestrator (it already delegates)
4. Add Omnigent policies (cost_budget, blast_radius) via YAML
5. Reuse mem0 + Qdrant + LightRAG for 3-layer memory
6. Add ClawRouter for cost optimization
7. Add x402 + Crossmint wallet for autonomous payments
8. Add nightly self-improvement cron job
9. Add war room (Obsidian logging, kill underperformers)

### Profile Mapping (Existing → Money-Earning)
| Existing Profile | Money-Earning Role | Changes Needed |
|-----------------|-------------------|----------------|
| ubek (orchestrator) | CEO orchestrator | Add money-earning mission to SOUL |
| builder | Implementer | Add dealwork task execution |
| content-creator | Proposal writer | Add bidding capabilities |
| code-developer | Code task implementer | Add dealwork API integration |
| deployer | x402 API deployer | Add x402 endpoint deployment |
| infra-admin | Financier | Add wallet monitoring, P&L |
| test-runner | QA reviewer | Add cross-vendor review |
| web-tester | Trend researcher | Add Etsy/scraping capabilities |
| — (NEW) | Opportunity scout | New profile: dealwork API polling |
| — (NEW) | Bidder | New profile: proposal submission |
| — (NEW) | Prediction trader | New profile: Polymarket trading |
