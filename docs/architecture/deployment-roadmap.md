# Deployment Roadmap — From Test to Full Autonomy

## Phase 0: Test Installation (Day 1)

### Step 1: Docker Isolation
```bash
# Create project directory
mkdir -p ~/autonomous-agent && cd ~/autonomous-agent

# Create docker-compose.yml (see omnigent-installation.md)
# Build and start
docker compose up -d

# Verify
docker compose ps
curl -s http://localhost:6767 | head -5
```

### Step 2: Install Omnigent in Container
```bash
# Enter container
docker compose exec omnigent bash

# Install
uv tool install omnigent
omnigent setup  # Add API keys

# Test
omnigent --version
omnigent server start
```

### Step 3: Run Polly Example (Learn Pattern)
```bash
omnigent run examples/polly/
# Observe: orchestrator delegates to sub-agents, cross-vendor review
```

### Step 4: Agent Wallet Setup
```bash
# Crossmint: create agent wallet
# Fund with small USDC deposit on Solana ($20 for testing)
# Set up x402 facilitator
```

**Deliverable:** Working Omnigent Docker instance, Polly pattern understood, wallet funded.

---

## Phase 1: First Earnings (Days 2-3)

### Step 5: Register on Agent-Native Platforms
```bash
# dealwork.ai — primary channel
# Register agent, get API key
# Test: GET /api/v1/jobs?eligibleWorkerTypes=ai_agent

# opentask.ai — backup
# Register, test API

# ugig.net — backup
# Register, test API
```

### Step 6: Deploy Opportunity Scout + Bidder
```bash
# Create agent YAMLs (see agent-roster.md)
omnigent run agents/opportunity-scout/config.yaml
omnigent run agents/bidder/config.yaml
```

### Step 7: First Bid + Win + Deliver
```
1. Scout finds $5-10 research task on dealwork.ai
2. Bidder generates proposal, bids mid-range
3. On acceptance → Implementer executes (research report)
4. Reviewer (different vendor) QA
5. Deliverer submits: POST /api/v1/contracts/{id}/events
6. Escrow releases (24h auto or approval)
7. Financier logs $5-10 revenue
```

**Deliverable:** First $1-10 earned autonomously on dealwork.ai.

---

## Phase 2: Multi-Stream (Days 4-7)

### Step 8: Add More Channels
- Superteam Earn (Solana bounties, $1000+ opportunities)
- ugig.net (clean API, $5-15 tasks)
- opentask.ai (USDC escrow)

### Step 9: x402 Passive Income
```bash
# Build useful API endpoint (crypto signals, data analysis)
# Deploy with x402 payment gate ($0.001-0.01 per call)
# List on MCP-Hive, Circle Marketplace, BuildMVPFast
```

### Step 10: Etsy Digital Products
```bash
# Etsy API v3 setup (OAuth 2.0, approved app)
# Printify API setup (for POD backup)
# Trend Researcher: scrape top sellers
# Implementer: create digital templates (budget, spreadsheet, planners)
# List via API (MODERATE PACE — no spray-and-pray!)
```

### Step 11: Financial Tracking
- Financier: daily P&L report
- Track per-channel ROI
- Crypto tax software (Koinly/CoinTracker) from day 1
- Log every transaction for Schedule C

**Deliverable:** 3+ earning channels active, first x402 passive income, Etsy store with 10-20 quality listings.

---

## Phase 3: Full Autonomy (Days 8-14)

### Step 12: "Space Station" Architecture
Deploy all 9 agents:
- Orchestrator (CEO)
- Opportunity Scout
- Bidder
- Implementer
- Reviewer (cross-vendor)
- Deliverer
- Financier
- Trend Researcher
- x402 API Seller

### Step 13: Memory System (Felix Pattern)
```bash
# Set up 3-layer memory
mkdir -p ~/life/{projects,areas,resources,archives}
# Layer 1: Knowledge graph (PARA)
# Layer 2: Daily notes (markdown)
# Layer 3: Tacit knowledge (preferences, rules)
# Vector embeddings in SQLite, local Ollama
```

### Step 14: Heartbeat + Nightly Self-Improvement
```yaml
# Orchestrator heartbeat: scan opportunities every hour
# Nightly loop:
#   1. Review all transcripts/logs
#   2. Identify blockers (where human intervention needed)
#   3. Devise permanent fix (new skill, better rules)
#   4. Update tacit knowledge layer
```

### Step 15: War Room + Obsidian Logging
```bash
# War room: kill underperforming channels/agents
# If channel ROI < 0 for 3 days → kill
# If agent consistently fails → reconfigure or replace
# Obsidian vault: all decisions, earnings, failures
```

### Step 16: Policy Enforcement
- cost_budget: $5/day hard cap
- blast_radius: deny catastrophic operations
- spawn_bounds: max 6 dispatches/turn
- headless_purpose_guard: only allowed purposes

**Deliverable:** Fully autonomous system running 24/7, nightly self-improvement, war room active, Obsidian accountability.

---

## Phase 4: Scale (Weeks 3-4+)

### Step 17: Add High-Value Channels
- MuleRun (launch bonuses $100-10k, platform absorbs LLM costs)
- Circle Agent Marketplace (enterprise visibility)
- Toku (fixed-price services, $50-500)

### Step 18: Expand x402 API Portfolio
- Multiple endpoints (different niches)
- List on all marketplaces
- Agent self-funding: x402 pays for compute

### Step 19: Agent-to-Agent Delegation (Felix Pattern)
- Hire sub-agents for support, sales
- Agent-to-agent bounties (like ClawGig pattern)
- Specialized agents per vertical

### Step 20: Legal Structure
- Form LLC (liability protection)
- Quarterly estimated taxes
- Crypto-native CPA consultation
- Insurance for agent-caused harm

### Step 21: Analytics Dashboard
- Omnigent Web UI (port 6767)
- Revenue per channel
- Cost per task
- ROI trends
- War room decisions log

**Deliverable:** Scaled system, multiple revenue streams, legal protection, analytics.

---

## Success Metrics

| Phase | Revenue Target | Cost Target | Channels | Autonomy Level |
|-------|---------------|-------------|----------|----------------|
| Phase 0 | $0 | $0 | 0 | Test |
| Phase 1 | $1-10 | <$1 | 1 | Semi-auto (first win) |
| Phase 2 | $50-200 | <$5/day | 3+ | Mostly auto |
| Phase 3 | $500-2k/mo | <$5/day | 5+ | Full auto + nightly improvement |
| Phase 4 | $5k-10k+/mo | <$5/day + x402 self-funding | 8+ | Full auto + agent delegation |

## Risk Checkpoints

### After Phase 1
- [ ] First payment received? (If no → check API, bidding strategy)
- [ ] Costs under $5/day? (If no → switch to cheaper models)

### After Phase 2
- [ ] ROI positive? (If no → kill low-ROI channels, war room)
- [ ] No platform bans? (If yes → review ToS compliance)

### After Phase 3
- [ ] Nightly improvement working? (If no → check memory system)
- [ ] Human intervention < 30 min/day? (If no → identify blockers)

### After Phase 4
- [ ] Tax records complete? (If no → CPA consultation)
- [ ] Legal structure in place? (If no → form LLC)
