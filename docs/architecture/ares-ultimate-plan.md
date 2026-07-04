# ARES (Autonomous Revenue Engine System) — Final Architecture (Revision #3)

## RESEARCH SOURCES INTEGRATED:
1. microsoft/agent-governance-toolkit (4.6k ⭐) — kill switch, SLO, sandboxing, policy enforcement
2. HKUDS/AI-Trader (20.4k ⭐) — Polymarket paper trading mode
3. AgentOps-AI/agentops (5.7k ⭐) — cost tracking, tracing, benchmarking
4. wpank/bardo — self-funding agent wallet, nightly memory compression (mori)
5. gosom/google-maps-scraper — drop-in Playwright lead scraper
6. amplifying-ai/awesome-generative-engine-optimization — AEO/GEO llms.txt best practices
7. EvoAgentX/Awesome-Self-Evolving-Agents (2.3k ⭐) — Layered Recursive Stack, metaprompt evolution
8. vectara/awesome-agent-failures (186 ⭐) — all known failure modes cataloged & mitigated
9. coinbase/agentkit — Base L2 agent wallet, USDC transfers, swaps
10. BlockRunAI/ClawRouter — agent-native LLM router, USDC micropayments

---

## FINAL DIRECTORY STRUCTURE: /opt/ares/

```
/opt/ares/
├── docker-compose.yml
├── config.yaml                      # Global Omnigent policies
├── policies/
│   ├── budget.yaml                  # $5/doba cap, auto-scale +20% net profit
│   ├── kill-switch.yaml             # Per-agent max-loss trigger (Microsoft Gov pattern)
│   ├── sandbox.yaml                 # Bubblewrap + no-network for implementer
│   └── slo.yaml                     # Latency <30s, success >80%, cost/task <$0.50
├── mcp-servers/
│   ├── agency-router.py             # 232 agents from The Agency plugin
│   ├── pm-skills.py                 # phuryn/pm-skills: ICP, GTM, pricing
│   ├── clawrouter.py                # ClawRouter: fund wallet + route requests
│   ├── agentops.py                  # AgentOps: cost tracking, traces, benchmarks
│   └── google-maps-scraper.py       # gosom/google-maps-scraper: lead generation
├── pm-skills/                       # Local fork of phuryn/pm-skills
├── agents/
│   ├── orchestrator.yaml            # CEO — Antigravity Gemini 3.5 Pro via OmniRoute
│   ├── scout.yaml                   # dealwork.ai + polymarket scan + outbound leads
│   ├── bidder.yaml                  # SalesGPT clone: proposals, MEDDPICC
│   ├── implementer.yaml             # Claude Code + Kilo in bubblewrap sandbox
│   ├── reviewer.yaml                # Cross-vendor QA: Pi/DeepSeek reviews Claude output
│   ├── deliverer.yaml               # Escrow release + API submission
│   ├── sdr-promoter.yaml            # Harvey clone + outbound-strategist + Google Maps scraper
│   ├── aeo-architect.yaml           # AEO/GEO: llms.txt, AGENTS.md, AI search optimization
│   ├── prediction-trader.yaml       # Polymarket/CloddsBot with PAPER TRADING MODE (week 1-2)
│   ├── insight-engine.yaml          # Nightly pattern analysis: WHY we earn/lose
│   ├── war-room.yaml                # Weekly kill/boost channel reallocation
│   └── financier.yaml               # Coinbase AgentKit + P&L + ClawRouter auto-funding
└── cron/
    ├── nightly-compress.yaml        # Bardo-inspired: daily notes → deduplicated facts DB
    ├── nightly-insight.yaml         # Pattern discovery + Tacit Failure Register update
    └── weekly-war-room.yaml         # Sunday 18:00 UTC: profitability audit + reallocate budget
```

---

## DEPLOYMENT SEQUENCE:

### PHASE 1 (Days 1-7): Foundation + Paper Trading
- Day 1: Create /opt/ares/ directory, docker-compose, config.yaml, policies/
- Day 2: Deploy all 5 MCP servers, integrate Coinbase AgentKit wallet
- Day 3: Deploy agent YAMLs (orchestrator through financier), connect OmniRoute proxy
- Day 4: Integrate HKUDS/AI-Trader paper trading for Polymarket
- Day 5: Connect dealwork.ai API, run first autonomous bid
- Day 6: Deploy Google Maps scraper + outbound prospecting pipeline
- Day 7: First closed loop: agent earns (paper), ClawRouter funded, cost tracking active

### PHASE 2 (Days 8-14): Live Trading + SaaS Sales
- Day 8: Paper trading review — if profitable, switch to LIVE USDC mode
- Day 9: Deploy AEO architect for Car Rent landing page (llms.txt generation)
- Day 10: SDR promoter: cold email campaign to scraped leads
- Day 11: Carousel growth engine + social media auto-publishing
- Day 12: Nightly compress + insight engine cron jobs activated
- Day 13: War room first run: profitability audit
- Day 14: Full autonomy: ARES earns, self-funds, evolves nightly

---

## FAILURE MODES ADDRESSED (from vectara/awesome-agent-failures):
1. CONTEXT OVERFLOW → Bardo nightly compression (cron job)
2. UNCHECKED SPENDING → Microsoft kill-switch per agent, $20 max auto-transaction
3. MODEL SYCOPHANCY → Cross-vendor review (Claude→DeepSeek, Gemini→Llama)
4. LOOP DEATH → Progressive constraints: 3 retries then ASK human
5. TOOL MISUSE → Bubblewrap sandbox: no filesystem access outside /workspace
6. GOAL DRIFT → SLO monitoring: if success rate drops below 50%, auto-pause agent
7. CREDENTIAL LEAK → OmniRoute proxy on Contabo, zero secrets on VPS
8. COST RUNAWAY → ClawRouter routes T1/T2 to free models, budget cap hard-enforced
9. DATA STALENESS → Nightly insight engine re-evaluates strategies against fresh data
10. OVERFITTING → Weekly war room kills strategies with negative ROI

---

## SELF-FUNDING LOOP:
```
Revenue (dealwork + Polymarket + SaaS subs)
    │
    ▼
Coinbase AgentKit Wallet (USDC on Base L2)
    │
    ├── 50% → ClawRouter auto-fund (API token budget)
    ├── 30% → Aave yield farming (5-12% APY)
    └── 20% → War chest (emergency buffer + HITL approvals)
    
Budget cap auto-scaling:
- Base: $5.00/day
- +20% of yesterday's net profit
- Example: ARES earns $50 net → tomorrow's cap = $5 + $10 = $15/day
```