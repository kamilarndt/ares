# Autonomous Money-Earning Agent Research KB

## Overview
Dogłębny research nad budową w pełni autonomicznego systemu agentów zarabiających pieniądze online bez udziału człowieka (HITL).

## Cel
Zaplanowanie wyizolowanej instalacji Omnigent + zaprojektowanie zestawu agentów do autonomicznego zarabiania pieniędzy online.

## Struktura KB

### 📁 platforms/
1. **agent-native-platforms.md** — 12+ platform dla agentów (dealwork.ai, opentask.ai, ugig.net, Superteam Earn, Circle, MCP-Hive, BuildMVPFast, MuleRun, execution.market, Toku, Near AI, etc.)
2. **traditional-platforms-tos.md** — Analiza ToS Upwork/Fiverr/Etsy (CO WOLNO, CO ZABRONIONE)
3. **payment-infrastructure.md** — x402, Crossmint, MoonPay, ERC-4337, Coinbase Agentic Wallets, agent self-funding loop

### 📁 technical/
4. **omnigent-installation.md** — Docker isolation, installation, policies, pitfalls, verification
5. **x402-protocol.md** — HTTP 402 payment protocol, flow, SDKs, implementation code
6. **platform-apis.md** — dealwork.ai REST API, Etsy API v3, Printify API, opentask.ai, Superteam Earn
7. **framework-comparison.md** — Omnigent vs OpenClaw vs LangGraph vs CrewAI vs AutoGen vs SwarmClaw vs n8n
8. **cost-optimization.md** — Model routing, ClawRouter, T1/T2/T3 task tiering, $5/day budget allocation
9. **tax-legal-implications.md** — AI agent tax law, attribution, recordkeeping, legal structures

### 📁 architecture/
10. **system-design.md** — Full architecture: Orchestrator + 9 sub-agents + payment + memory + logging
11. **agent-roster.md** — 9 agent YAML configs mapped to existing ~/05-Agents/ personas
12. **deployment-roadmap.md** — 4-phase roadmap from test to full autonomy (21 steps)

### 📁 case-studies/
13. **felix-openclaw.md** — Felix case study ($260k+, soul file, 3-layer memory, nightly improvement)
14. **proven-earnings.md** — 12 documented earning cases with real numbers
15. **prediction-markets.md** — Polymarket autonomous trading, BlockRunAI stack, ClawRouter

## Kluczowe Odkrycia

### 1. BlockRunAI — Kompletny Autonomous Earning Stack
- **ClawRouter** — open-source LLM router z USDC payments (70-78% oszczędności)
- **polymarket-agent** — autonomous prediction market trader (self-funding)
- **BlockRun** — open-source Claude Code/Cursor alternative
- **Wszystko MIT licensed, self-hosted, wallet-based auth**

### 2. dealwork.ai — Najlepsza Platforma Startowa
- 100% payment reliability, 3-7 bids/job, USDC escrow + Stripe
- AUTO_APPROVE po 24h, 3% fee AI-to-AI
- REST API: GET /jobs, POST /bids, POST /events

### 3. x402 Protocol — Payment Standard
- 20M+ transakcji w Jan 2026, $165M+ volume
- Founding: Visa, Google, AWS, Stripe, Coinbase
- Agent płaci za compute i sprzedaje API endpoints (passive income)

### 4. Felix Pattern — Najlepiej Udokumentowany
- $260k+ revenue, $400-1500/mo costs
- Klucz: 3-layer memory, soul file, nightly self-improvement
- "Get the memory structure in first" — biggest unlock

### 5. Prediction Markets — Najszybsza Ścieżka
- 70% top-earning wallets to bots
- $5-20/day net z 1 SOL na cheap models
- Same model+data, różna architektura: $1,200 vs $4,200/mo

## Zalecenia Architektury

### Hybrid: Omnigent + OpenClaw patterns + BlockRunAI stack
1. **Omnigent** Docker (isolation, policies, Polly pattern, cross-vendor review)
2. **OpenClaw patterns** (soul file, 3-layer memory, heartbeat, nightly improvement)
3. **ClawRouter** (model routing, USDC payments, 70%+ savings)
4. **dealwork.ai** API (primary freelance channel)
5. **Polymarket** (prediction markets, self-funding)
6. **x402** (passive API income, self-funding compute)
7. **Etsy** digital products (passive, API-managed)
8. **$5/day** cost cap (cost_budget policy)
9. **9 agents** (orchestrator, scout, bidder, implementer, reviewer, deliverer, financier, trend researcher, x402 seller + prediction trader)

### 📁 case-studies/ (continued)
16. **failure-modes.md** — 7 failure patterns, Andon Café ($6k loss), 500-day sim (3/25 survived), mitigation framework
17. **contabo-awa-analysis.md** — Analiza istniejącego systemu AWA na Contabo (Belfort orchestrator, 11 profili, gap analysis)

## Contabo — Co Już Istnieje

**Belfort AWA (Autonomous Wealth Agent)** — gotowy system na Contabo:
- 18 profili Hermes, aktywne: belfort (orchestrator)
- 11 workerów: anti-sycophant, research-pro, market-scout, content-publisher, quality-review, revenue-ops, service-bot, freelance-hunter, pm, frontend-dev, web-navigator
- 12 skilli AWA (awa-anti-sycophant, awa-daily-reflection, awa-pipeline, etc.)
- Heartbeat cron (aktywny, updated Jul 3)
- mem0 + Qdrant (localhost:6333)
- OmniRoute gateway (localhost:18881)
- mcp-omniroute server
- 232 zewnętrznych specjalistów (agency-agents-router)
- Kanban (kanban.db 598KB)
- Plan akcji (Jun 30): GO na x402 infra + vertical micro-agent
- Research docs: 10+ plików (payments, market report, micro-agents, AI SDR, UBEK)

**Gap analysis:** brak sandbox isolation, brak policy enforcement (cost_budget, blast_radius), freelance-hunter szuka na Fiverr/Upwork (zły platform — powinien dealwork.ai), anti-sycophant ten sam vendor (brak cross-vendor review), brak x402/payment integration (planowane ale nie zbudowane).

### 📁 architecture/ (4 pliki)
10. **system-design.md** — Full architecture: Orchestrator + 9 sub-agents + payment + memory + logging
11. **agent-roster.md** — 9 agent YAML configs mapped to existing ~/05-Agents/ personas
12. **deployment-roadmap.md** — 4-phase roadmap from test to full autonomy (21 steps)
13. **contabo-analysis.md** — Analiza istniejącej infrastruktury Contabo (11 profili, Honcho, mem0, LightRAG)

### 📁 case-studies/ (4 pliki)
14. **felix-openclaw.md** — Felix case study ($260k+, soul file, 3-layer memory, nightly improvement)
15. **proven-earnings.md** — 12 documented earning cases with real numbers
16. **prediction-markets.md** — Polymarket autonomous trading, BlockRunAI stack, ClawRouter
17. **failure-modes.md** — 88% pilot failure rate, Andon Café $6k loss, 7 failure modes + mitigations

### 📁 architecture/ (5 plików)
18. **handoff.md** — Kompletny handoff sesji: co zrobione, co zostało, architektura, todo

## Status
Handoff zapisany. ARES w budowie — Budget Intelligence zbudowany i działa na Contabo. 14 zadań w todo, 2 zrobione (budget system), reszta czeka na kolejną sesję.

## Linki
- Diagram ARES: https://excalidraw.com/#json=79_9Nyyj6R2v9nh1GliXh,_qy0x3Wy_NF1i_BtQMDDNQ
- Slideshow: /tmp/ares-slideshow.html (otwórz w przeglądarce, strzałki do nawigacji)
