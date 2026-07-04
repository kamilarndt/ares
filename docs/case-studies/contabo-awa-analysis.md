# Contabo — Existing AWA (Autonomous Wealth Agent) System Analysis

## Data: July 3, 2026
## Source: SSH inspection of Contabo VPS (vmi3297085, Ubuntu, x86_64)

---

## CRITICAL FINDING: System Already Exists

Kamil has ALREADY BUILT an autonomous earning agent system on Contabo. It's called **AWA (Autonomous Wealth Agent)** and the orchestrator profile is **Belfort** (named after Jordan Belfort, Wolf of Wall Street).

**80% of the architecture I designed in research already exists here.**

---

## What Exists

### 1. Belfort Orchestrator (Active Profile)
- **Location:** /opt/hermes/profiles/belfort/
- **SOUL.md:** Revenue-first, anti-sycophant AWA orchestrator
- **Model:** opencode-go/mimo-v2.5 via https://opencode.ai/zen/go/v1 (FREE)
- **State:** state.db = 77MB (active, growing)
- **Gateway:** Running (gateway.lock, gateway.pid, gateway_state.json)
- **Heartbeat cron:** ticker_heartbeat + ticker_last_success (both updated today Jul 3)
- **Profile.yaml:** "Orchestrator AWA — koordynuje workerów, pilnuje revenue-first i anti-sycophant, deleguje via Kanban."

### 2. SOUL.md Core Directives
```
Role: Orchestrator AWA — koordynujesz wyspecjalizowane profile-workery
Personality: Revenue-first, anti-sycophant, szybka walidacja + reinwestycja
Memory: Atomic Memory z kategoriami: ideas, lessons, experiments, rejected-ideas

Success Metrics:
- Trafność routingu: ≥90%
- Weryfikacja: 100% delegowanych tasków zweryfikowanych niezależnie
- Równoległość: ≥60% tasków delegowanych batchowo
- Eskalacja: max 2 próby przed kanban_block do człowieka

Daily Loop:
1. Rano (08:00) — opportunity scan → wybierz cel dnia
2. Dzień — deleguj do workerów, zbieraj wyniki
3. Przed akcją — anti-sycophant: GO/PIVOT/STOP
4. Wieczór (22:00) — refleksja → zapisz do pamięci

Rules:
- Decyzja >100 PLN → human-in-the-loop (kanban_block)
- Zero zbędnych pytań (clarify OFF)
- 232 zewnętrznych specjalistów via agency-agents-router
```

### 3. 11 Worker Profiles

| Profile | Role | SOUL.md | Status |
|---------|------|---------|--------|
| anti-sycophant | GO/PIVOT/STOP verification + ROI + risk | ✓ | Active |
| research-pro | Deep research, sources, data, synthesis | ✓ | Active |
| market-scout | Market analysis, prices, competitors, margins | ✓ | Active |
| content-publisher | Content creation, blog, posts, newsletters | ✓ | Active |
| quality-review | PASS/FAIL quality control + fixes | ✓ | Active |
| revenue-ops | Revenue, costs, profit, pipeline reporting | ✓ | Active |
| service-bot | Service delivery, customer support | ✓ | Active |
| freelance-hunter | Finds freelancers on Fiverr/Upwork/Useme | ✓ | Active |
| pm | Project and task management | ✓ | Active |
| frontend-dev | UI implementation (Next.js, React, Tailwind) | ✓ | Active |
| web-navigator | Web interactions, forms, publishing | ✓ | Active |

**Plus:** ai-engineer, devops, ubek, web-tester (additional profiles)

### 4. 12 AWA Skills
- awa-anti-sycophant — decision verification
- awa-content-publishing — content workflows
- awa-daily-reflection — evening reflection loop
- awa-deep-research — research methodology
- awa-market-analysis — market analysis
- awa-pipeline — pipeline management
- awa-quality-review — quality gates
- awa-revenue-report — financial reporting
- council — hermes-council integration
- dispatching-parallel-agents — batch delegation
- executing-plans — plan execution
- grok-mcp-server — Grok MCP integration
- infrastructure — infra management
- profiles-catalog — profile registry
- quality — quality framework
- remote-cdp-browser — browser automation
- using-superpowers — power user skills
- writing-plans — plan authoring

### 5. Research Already Done (on Contabo)

| Document | Size | Content |
|----------|------|---------|
| plan_akcji_ai_agent_monetization.md | 3KB | GO decision, x402 infra + vertical micro-agent plan |
| raport_autonomiczne_agenty_ai.md | 17KB | Comprehensive market report (market size, platforms, frameworks) |
| agent_payments_research.md | 14KB | x402 deep dive, GitHub repos, ecosystem |
| research-vertical-micro-agents.md | 8KB | Prospecting agents, Earendel case, open-source tools |
| research_ai_staff_augmentation.md | 12KB | AI staff augmentation research |
| ai_agent_monetization_report.md | 15KB | Monetization report (in research_output/) |
| aisdr-go-to-market.md | 10KB | AI SDR go-to-market |
| aisdr-prd-auto-refill.md | 13KB | AI SDR PRD |
| aisdr-roadmap-q3-q4-2026.md | 13KB | AI SDR roadmap |
| ubek-experiment-doc.md | 18KB | UBEK experiment |
| ubek-ux-audit-report.md | 24KB | UBEK UX audit |

### 6. Infrastructure

| Component | Version/Status | Purpose |
|-----------|---------------|---------|
| Docker | 29.5.3 | Container runtime |
| Docker Compose | v5.1.4 | Container orchestration |
| Python | 3.12.3 | Runtime |
| Node.js | 22.22.2 | Runtime |
| PM2 | Running 6 processes | Process manager |
| Cloudflared | Online (39h uptime) | Tunnel |
| mcp-v7 | Online (25h, 181 restarts) | MCP server |
| pm-bridge | Online (9D) | PM bridge service |
| ubek-agent | Online (2D) | UBEK agent |
| ubek-next-new | Online (2D) | UBEK frontend |
| car-rent-app | Online (14m) | Car rental app |
| mem0 | OSS mode | Memory (Qdrant + OpenAI-compat) |
| Qdrant | localhost:6333 | Vector store |
| OmniRoute gateway | localhost:18881 | LLM gateway |
| mcp-omniroute | /root/mcp-omniroute/ | MCP server for OmniRoute |

### 7. Mem0 Configuration
```json
{
  "mode": "oss",
  "user_id": "profile-belfort",
  "agent_id": "belfort",
  "llm": "router://auto via localhost:18881",
  "embedder": "text-embedding-3-small via localhost:18881",
  "vector_store": "Qdrant at localhost:6333, collection hermes_memories_contabo"
}
```

### 8. Plan Akcji (June 30, 2026)
- **Decision:** GO on AI agent monetization
- **Niche 1:** x402 payment infrastructure + cost monitoring (⭐⭐⭐⭐⭐)
- **Niche 2:** Vertical micro-agent — prospecting for freelancers (⭐⭐⭐⭐)
- **CAPEX:** ~$500
- **Timeline:** MVP in 7 days
- **Revenue model:** SaaS ($20-100/mo) + % from transactions (0.5-1%)
- **Stack:** Python + FastAPI + x402 API + OpenAI/Anthropic API + SQLite/Postgres

---

## Gap Analysis: What AWA Has vs What Research Recommends

| Feature | AWA (Contabo) | Research Recommendation | Gap |
|---------|---------------|------------------------|-----|
| Orchestrator | Belfort ✓ | CEO agent ✓ | NONE |
| Worker profiles | 11 profiles ✓ | 9 sub-agents ✓ | NONE (AWA has more) |
| Daily loop | Heartbeat cron ✓ | Nightly self-improvement ✓ | NONE |
| Memory | mem0 + categories ✓ | 3-layer memory ✓ | PARTIAL (no knowledge graph) |
| Anti-sycophant | Same vendor ❌ | Cross-vendor review ✓ | GAP (need different vendor) |
| Cost control | revenue-ops tracks | $5/day hard cap ❌ | GAP (no hard enforcement) |
| Sandbox | None ❌ | Docker/bubblewrap ✓ | GAP (runs in main process) |
| Policies | None ❌ | cost_budget, blast_radius ✓ | GAP (no policy enforcement) |
| Payment infra | Planned (plan akcji) | x402 + Crossmint ✓ | GAP (not yet built) |
| Earning channels | freelance-hunter (Fiverr/Upwork) | dealwork.ai, Polymarket, x402 | GAP (wrong platforms) |
| Model routing | opencode-go/mimo-v2.5 (free) | ClawRouter + tiers ✓ | PARTIAL (single model) |
| Agency agents | 232 specialists ✓ | — | BONUS (AWA has this) |
| Kanban | kanban.db (598KB) ✓ | — | BONUS (AWA has this) |
| Gateway | Running ✓ | — | BONUS (AWA has this) |

---

## How Omnigent Fits Into Existing AWA System

### Option A: Omnigent as Execution Layer (RECOMMENDED)
- Belfort keeps orchestration (decides WHAT, WHO)
- Omnigent provides sandboxed execution + policies + cross-vendor review
- Worker profiles become Omnigent agents with YAML configs
- Add: cost_budget ($5/day), blast_radius, spawn_bounds policies
- Use: Omnigent sandbox for safe code execution
- Benefit: Policies protect against runaway costs, catastrophic actions

### Option B: Omnigent Replaces Belfort Orchestration
- Migrate all profiles to Omnigent YAML agents
- Use Polly pattern for orchestration
- Lose: Kanban, gateway, agency-agents-router, mem0 integration
- Risk: Breaking working system
- NOT RECOMMENDED

### Option C: Parallel Systems
- Belfort for Hermes-native tasks (research, content, market analysis)
- Omnigent for coding/multi-vendor tasks (implementation, review)
- Bridge: Belfort delegates to Omnigent when needed
- Benefit: Best of both worlds
- Complexity: Two orchestration systems

### Option D: Enhance AWA with Research Findings
- Keep Belfort as-is
- Add: dealwork.ai integration to freelance-hunter
- Add: prediction market agent (new profile)
- Add: x402 API seller (new profile)
- Add: cost_budget policy (manual enforcement)
- Add: cross-vendor review (use different model for anti-sycophant)
- Add: ClawRouter for model routing
- Benefit: Minimal disruption, fills gaps
- Risk: No sandbox isolation

---

## Recommended Action Plan

### Phase 1: Fill Critical Gaps (Days 1-3)
1. Add dealwork.ai integration to freelance-hunter (agent-native platform, not Fiverr/Upwork)
2. Add prediction market agent (new profile: prediction-trader)
3. Switch anti-sycophant to different model vendor (cross-vendor review)
4. Add cost tracking with $5/day hard cap (revenue-ops enhancement)
5. Install ClawRouter for model routing (70%+ cost savings)

### Phase 2: Add Omnigent (Days 4-7)
1. Install Omnigent in Docker on Contabo
2. Create YAML configs for key workers (implementer, reviewer)
3. Add policies: cost_budget, blast_radius, spawn_bounds
4. Bridge Belfort → Omnigent for coding tasks
5. Test: Belfort delegates implementation → Omnigent sandboxed execution

### Phase 3: Add Earning Channels (Days 8-14)
1. x402 API endpoint (passive income)
2. Etsy digital products (new profile: etsy-seller)
3. MCP server monetization (Nevermined paywall)
4. DeFi yield (Financier/revenue-ops enhancement)

### Phase 4: Full Autonomy (Weeks 3-4)
1. Nightly self-improvement loop (enhance awa-daily-reflection)
2. War room (kill underperforming channels)
3. Knowledge graph memory (Layer 1 of 3-layer memory)
4. Agent wallet (Crossmint/USDC on Solana)

---

## Key Resources on Contabo

| Path | Purpose |
|------|---------|
| /opt/hermes/ | Main Hermes installation |
| /opt/hermes/profiles/belfort/ | Belfort orchestrator profile |
| /opt/hermes/profiles/ | All 18 profiles |
| /opt/hermes/skills/awa/ | AWA skills (8 skills) |
| /opt/hermes/kanban.db | Kanban task database |
| /opt/hermes/state.db | State database (77MB) |
| /root/.local/bin/belfort | Belfort launcher (hermes -p belfort) |
| /root/mcp-omniroute/ | MCP server for OmniRoute |
| /root/plan_akcji_ai_agent_monetization.md | Monetization plan |
| /root/raport_autonomiczne_agenty_ai.md | Market report |
| /root/agent_payments_research.md | x402 payment research |
| /root/research-vertical-micro-agents.md | Micro-agent research |
| /root/research_output/ | Research output dir |
| /root/investment_analysis/ | Investment analysis |
