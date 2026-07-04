# System Design — Autonomous Money-Earning Agent Architecture

## Design Philosophy

Three proven patterns combined:
1. **Polly pattern** (Omnigent): Orchestrator writes no code, delegates to sub-agents, cross-vendor review
2. **Space Station pattern** (X/Twitter): Specialized rooms for research, creation, publishing, comms, war room
3. **Felix pattern** (OpenClaw): Soul file, 3-layer memory, nightly self-improvement, heartbeat

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OMNIGENT DOCKER (isolated)                 │
│                    Port 6767 · Non-root user                  │
│  ┌───────────────────────────────────────────────────────┐   │
│  │           ORCHESTRATOR ("Ultron" / CEO)                │   │
│  │  Hermes or claude-sdk brain · 1M context window       │   │
│  │  Soul file: "Build $10k/mo with zero human employees" │   │
│  │  3-layer memory: Knowledge graph / Daily notes / Tacit│   │
│  │  Heartbeat: proactive task initiation                 │   │
│  │  Nightly self-improvement: review blockers, fix       │   │
│  ├───────────────────────────────────────────────────────┤   │
│  │  POLICIES (guardrails):                                │   │
│  │  cost_budget: $5/day hard cap, $3 warn                │   │
│  │  blast_radius: deny force-push, rm -rf                │   │
│  │  spawn_bounds: max 6 dispatches/turn                  │   │
│  │  headless_purpose_guard: [bid, deliver, implement,    │   │
│  │    review, explore, search]                           │   │
│  │  ask_timeout: 86400 (unattended)                      │   │
│  ├───────────────────────────────────────────────────────┤   │
│  │  SUB-AGENTS (each own session/worktree):              │   │
│  │                                                        │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
│  │  │OPPORTUNITY   │  │ BIDDER       │  │ IMPLEMENTER │  │   │
│  │  │SCOUT         │  │              │  │             │  │   │
│  │  │Hermes/cheap  │  │Cheap model   │  │Claude/Codex │  │   │
│  │  │              │  │high speed    │  │strong model │  │   │
│  │  │Poll:         │  │              │  │             │  │   │
│  │  │-dealwork.ai  │  │Generate      │  │Execute won  │  │   │
│  │  │-opentask.ai  │  │proposals     │  │tasks: code, │  │   │
│  │  │-ugig.net     │  │              │  │content,     │  │   │
│  │  │-Superteam    │  │Auto-submit   │  │scraping,    │  │   │
│  │  │              │  │on agent-     │  │analysis     │  │   │
│  │  │Scrape:       │  │native only   │  │             │  │   │
│  │  │-Etsy trends  │  │              │  │Drive to     │  │   │
│  │  │-Twitter jobs │  │Upwork: draft │  │green (QA)   │  │   │
│  │  │              │  │+ human queue │  │             │  │   │
│  │  │Filter:       │  │              │  │Open PR /    │  │   │
│  │  │ROI > thresh  │  │              │  │deliver      │  │   │
│  │  │legal, doable │  │              │  │             │  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │   │
│  │                                                        │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
│  │  │REVIEWER      │  │ DELIVERER    │  │ FINANCIER   │  │   │
│  │  │              │  │              │  │             │  │   │
│  │  │DIFFERENT     │  │Cheap model   │  │Hermes/cheap │  │   │
│  │  │vendor than   │  │+ API tools   │  │             │  │   │
│  │  │implementer   │  │              │  │Monitor USDC │  │   │
│  │  │              │  │Submit work   │  │wallets      │  │   │
│  │  │Pi/Hermes/    │  │via platform  │  │(Crossmint/  │  │   │
│  │  │OpenCode      │  │API           │  │x402)        │  │   │
│  │  │              │  │              │  │             │  │   │
│  │  │Cross-vendor  │  │Handle client │  │Track P&L    │  │   │
│  │  │QA on all     │  │communication │  │per task     │  │   │
│  │  │deliverables  │  │              │  │             │  │   │
│  │  │              │  │Trigger       │  │Auto-reinvest│  │   │
│  │  │Blocking/     │  │escrow release│  │in API creds │  │   │
│  │  │non-blocking  │  │              │  │             │  │   │
│  │  │issues        │  │              │  │Daily report:│  │   │
│  │  │              │  │              │  │rev, costs,  │  │   │
│  │  │Quality gate  │  │              │  │ROI          │  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │   │
│  │                                                        │   │
│  │  ┌─────────────┐  ┌─────────────┐                     │   │
│  │  │TREND         │  │ X402 API     │                     │   │
│  │  │RESEARCHER    │  │ SELLER       │                     │   │
│  │  │              │  │              │                     │   │
│  │  │Pi/Hermes     │  │Self-hosted   │                     │   │
│  │  │explore mode  │  │endpoint      │                     │   │
│  │  │              │  │              │                     │   │
│  │  │Scrape        │  │Sell API      │                     │   │
│  │  │validated     │  │calls:        │                     │   │
│  │  │demand        │  │$0.001-0.01   │                     │   │
│  │  │              │  │per call      │                     │   │
│  │  │Identify new  │  │              │                     │   │
│  │  │earning       │  │List on:      │                     │   │
│  │  │verticals     │  │-MCP-Hive     │                     │   │
│  │  │              │  │-Circle       │                     │   │
│  │  │Feed          │  │-BuildMVPFast │                     │   │
│  │  │opportunities │  │              │                     │   │
│  │  │to scout      │  │PASSIVE INCOME│                     │   │
│  │  └─────────────┘  └─────────────┘                     │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐   │
│  │  PAYMENT INFRASTRUCTURE                                │   │
│  │  Crossmint wallet → USDC on Solana                     │   │
│  │  x402: agent pays for own compute, sells API endpoints │   │
│  │  dealwork.ai escrow → auto-release after 24h           │   │
│  │  Superteam Earn → SOL/USDC bounties                    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐   │
│  │  MEMORY (3-Layer, Felix pattern)                       │   │
│  │  Layer 1: Knowledge graph (~/life/ PARA system)        │   │
│  │  Layer 2: Daily notes (markdown, nightly consolidation)│   │
│  │  Layer 3: Tacit knowledge (preferences, rules, lessons)│   │
│  │  Vector embeddings in SQLite, local Ollama models      │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐   │
│  │  OBSIDIAN LOGGING (accountability)                     │   │
│  │  War room: kill underperformers                        │   │
│  │  Archives: all decisions, earnings, failures           │   │
│  │  Analytics: revenue, costs, ROI per channel            │   │
│  └───────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Active Earning Loop (Freelance)
```
1. Opportunity Scout polls dealwork.ai API
   GET /api/v1/jobs?eligibleWorkerTypes=ai_agent
2. Scout filters: ROI > threshold, legal, achievable
3. Scout ranks opportunities → sends to Orchestrator
4. Orchestrator dispatches to Bidder
5. Bidder generates proposal, submits bid
   POST /api/v1/jobs/{id}/bids
6. On acceptance → Orchestrator dispatches to Implementer
7. Implementer executes task (code/content/scraping)
8. Implementer delivers to Reviewer (different vendor)
9. Reviewer QA: blocking/non-blocking issues
10. If pass → Deliverer submits work
    POST /api/v1/contracts/{id}/events {"type": "SUBMIT_WORK"}
11. Escrow releases (auto after 24h or on approval)
12. Financier logs revenue, updates P&L
13. Nightly: Orchestrator reviews blockers, self-improves
```

### Passive Earning Loop (x402 API)
```
1. Trend Researcher identifies useful API to build
2. Implementer builds API endpoint
3. Deploy with x402 payment gate
4. List on MCP-Hive, Circle Marketplace, BuildMVPFast
5. Agents worldwide call API → pay USDC per call
6. Financier tracks passive revenue
7. Agent uses x402 to pay for own compute (self-funding)
```

### Passive Earning Loop (Etsy Digital Products)
```
1. Trend Researcher scrapes Etsy top sellers
2. Identifies validated demand (what's selling)
3. Implementer creates digital product (template, PDF)
4. Reviewer checks quality, originality
5. Deliverer lists via Etsy API v3 (moderate pace!)
6. SEO-optimize title, description, tags
7. Sales → automatic digital delivery
8. Financier tracks revenue
```

## Key Design Decisions

### Why Omnigent (not pure OpenClaw)?
- Built-in policies (cost_budget, blast_radius, spawn_bounds)
- Cross-vendor review (Polly pattern)
- Docker isolation
- Session persistence
- But: adopt OpenClaw patterns (memory, heartbeat, soul file, nightly improvement)

### Why dealwork.ai as primary channel?
- 100% payment reliability (7/7 contracts paid)
- 3-7 bids per job (better odds)
- USDC escrow + Stripe
- AUTO_APPROVE after 24h
- Legal for full autonomy

### Why x402 for payments?
- Agent pays for own compute (self-funding)
- Sells API endpoints (passive income)
- No credit cards, no banks needed
- Sub-cent transactions
- Industry backing (Visa, Google, AWS, Stripe, Coinbase)

### Why $5/day cost cap?
- Matches user's existing budget constraint
- Prevents runaway spending
- Forces cheap model usage for T1 tasks
- Strong models only for implementation/review
- x402 self-funding offsets costs over time

### Why 3-layer memory?
- Prevents context loss across sessions
- Enables long-term learning
- Nightly consolidation extracts important facts
- Tacit knowledge makes agent feel personalized
- Felix proved this is "the single biggest unlock"

### Why nightly self-improvement?
- Reviews all transcripts/logs
- Identifies blockers (where human intervention was needed)
- Devises permanent fixes (new skills, better rules)
- Compounds autonomy over time
- Key to reducing human involvement to ~0
