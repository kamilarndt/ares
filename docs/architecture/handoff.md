# ARES — Handoff

## Data: 2026-07-03 19:30
## Status: W trakcie budowy Fazy 1

---

## Cel Systemu
Zbudowanie w pełni autonomicznego agenta AI do zarabiania pieniędzy online.
System ma się samofinansować — zarabiać na tokeny które zużywa, uczyć się z porażek i ewoluować każdej nocy.

---

## Co Zrobiono (Iteracje Researchu)

### Iteracja 1-3: Research bazowy
- 12+ platform agent-native (dealwork.ai, opentask.ai, Superteam Earn, Polymarket)
- BlockRunAI stack: ClawRouter (70% oszczędności), polymarket-agent (self-funding)
- x402 protocol: 20M transakcji, $165M volume, Visa/Google/Stripe backing
- Felix case ($260k), Andon Café ($6k loss), 500-day startup sim (3/25 survived)
- Frameworki: Omnigent vs OpenClaw vs LangGraph vs CrewAI vs AutoGen
- Microsoft Agent Governance Toolkit (kill switch, SLO, chaos testing)
- Mem0, Qdrant, Letta memory architecture

### Iteracja 4: 24 nowe repozytoria przeanalizowane

| Repozytorium | Stars | Zastosowanie w ARES |
|---|---|---|
| `msitarzewski/agency-agents` | 126k ⭐ | Baza 1000+ agentów (oryginał, nie plugin 232) |
| `DietrichGebert/ponytail` | 72k ⭐ | Lazy senior dev mindset dla implementera |
| `mem0ai/mem0` | 60k ⭐ | Memory layer (już działa na Contabo) |
| `Panniantong/Agent-Reach` | 49k ⭐ | Darmowy research (Twitter, Reddit, GitHub) |
| `ComposioHQ/composio` | 19k ⭐ | 250+ integracji, zastępuje custom MCP |
| `letta-ai/letta` | 14k ⭐ | Memory Blocks pipeline (zastępuje nightly-compress) |
| `dzhng/deep-research` | 18k ⭐ | Multi-hop research pattern dla scouta |
| `searxng/searxng` | 17k ⭐ | Self-hosted metasearch (darmowy) |
| `addyosmani/agent-skills` | — | Oficjalne Google AEO patterny |
| `hermes-council` | — | Formal council debate zamiast reviewera |
| `council-of-high-intelligence` | 3k ⭐ | 5-osobowy council system |
| `DeepSpec` | 6k ⭐ | Spec-driven development |
| `ciembor/agent-rules-books` | 4k ⭐ | Gotowe templates dla agent YAML-i |
| `free-for-dev` | 93k ⭐ | Auto-discovery darmowych narzędzi |
| `codebase-memory-mcp` | 25k ⭐ | Codebase memory dla implementera |
| `Ilograph` | — | Auto-dokumentacja architektury |

### Infrastruktura Contabo (zbadane)

- Docker działa: hermes-ubek, mem0-postgres, qdrant
- PM2: car-rent-app (port 3003), ubek-next-new (port 3001), mcp-v7 (port 8443), cloudflared
- Caddy TLS, OmniRoute proxy (port 20128) → WSL2
- 18 profili Hermes, aktywne: belfort (AWA), ubek
- 11 workerów: builder, deployer, infra-admin, backend-dev, frontend-dev, code-developer, content-creator, test-runner, web-tester
- LightRAG server (port 9621), Honcho server (port 8000)
- 3 cron joby: backlog sweep, health-check, session cleanup

### System Inteligentnego Budżetowania (zbudowany)

**Pliki:**
- `/opt/ares/policies/tier-config.yaml` — 4 tiers: bootstrap → earning → profitable → scale
- `/opt/ares/mcp-servers/budget-intelligence.py` — MCP server z 3 narzędziami
- `/opt/ares/cron/weekly-model-refresh.sh` — cotygodniowa analiza value modeli

**Jak działa:**
1. START: BOOTSTRAP ($1/dzień, tylko darmowe modele)
2. $3/dzień zysku → EARNING ($3 budżet, GLM-5.1, Qwen)
3. $15/dzień zysku → PROFITABLE ($6 budżet, Gemini Flash, Claude Sonnet)
4. $50/dzień zysku → SCALE (nieograniczony, Claude Opus tylko krytyczne)

**Potwierdzone:**
- 53 modele z rankingami ELO w OmniRoute
- Najlepsze value: mimo-v2.5 (FREE, value 49.56), qwen3.6-plus ($0.15, value 3.75)
- Chińskie modele (GLM, Qwen, DeepSeek) dają 90% jakości za 10% ceny
- Claude Opus = 1000x gorsze value niż darmowe modele
- 49 potencjalnych swapów: GLM-5.2 ($0.50) → GLM-5.1 ($0.14, 109% jakości, 72% oszczędności)

---

## Architektura ARES (Finał)

### Struktura katalogów:
```
/opt/ares/
├── docker-compose.yml              # Jeszcze nie utworzony
├── config.yaml                     # Jeszcze nie utworzony
├── policies/
│   └── tier-config.yaml            # ✅ Utworzony na Contabo
├── mcp-servers/
│   └── budget-intelligence.py      # ✅ Utworzony na Contabo (działa przez API)
├── cron/
│   └── weekly-model-refresh.sh     # ✅ Utworzony lokalnie, czeka na deploy
├── agents/                         # 11 YAML-i, jeszcze nie utworzone
├── skills/                         # Zaimportowane skille z addyosmani, hermes-council, ponytail
└── docs/
    └── architecture.ilograph       # Interaktywny diagram
```

### 11 agentów (YAML-i do napisania):
1. **orchestrator.yaml** — CEO, Antigravity Gemini 3.5 Pro, 1M context
2. **scout.yaml** — Agent-Reach + SearXNG + deep-research pattern
3. **bidder.yaml** — SalesGPT + MEDDPICC + Composio email
4. **implementer.yaml** — Claude Code + ponytail + DeepSpec + bubblewrap
5. **council.yaml** — 5-osobowa debata: Optimist, Skeptic, Systems Thinker, FPP, Synthesizer
6. **deliverer.yaml** — Escrow trigger + Composio API submission
7. **sdr-promoter.yaml** — Harvey + Agent-Reach + Composio Google Maps
8. **aeo-architect.yaml** — addyosmani/agent-skills: llms.txt, AGENTS.md
9. **prediction-trader.yaml** — Polymarket + PAPER TRADING MODE
10. **financier.yaml** — Coinbase AgentKit + ClawRouter + free-for-dev
11. **insight-engine.yaml** — Pattern analysis + failure register

### 4 kanały zarobkowe:
- A. FREELANCE (dealwork.ai) — USDC escrow, 100% payment rate
- B. PREDYKCJA (Polymarket/Kalshi) — Paper trading 2 tygodnie przed LIVE
- C. SaaS SALES (Car Rent) — AEO-first, Google Maps scraper, cold email
- D. PASSIVE (x402 API) — $0.001-0.01/call, MCP-Hive, Circle Marketplace

### 10 zabezpieczeń (z awesome-agent-failures):
1. Letta Memory Blocks → overflow ochroniony
2. Microsoft Governance kill switch → max $20 bez zgody
3. Council 5 modeli → zero sycophancy
4. 3 próby → ASK human → infinite loop ochroniony
5. Bubblewrap sandbox → tool misuse ochroniony
6. SLO monitoring → auto-pause przy success rate <50%
7. OmniRoute proxy → zero sekretów na VPS
8. ClawRouter T1/T2 routing → 70% taniej niż zawsze Claude
9. Nightly insight → świeże dane, nie stare
10. War Room → killuje ujemne ROI, boostuje profitable

---

## Zadania Otwarte (Todo)

| # | Zadanie | Status |
|---|---|---|
| 1 | Deploy /opt/ares/ na Contabo | ✅ Struktura, brak docker-compose |
| 2 | docker-compose.yml + config.yaml + polityki | ❌ |
| 3 | Wszystkie MCP serwery (agency, pm, clawrouter, composio, agent-reach) | ❌ |
| 4 | 11 agent YAML | ❌ |
| 5 | Integracja OmniRoute proxy | ✅ Działa (port 20128) |
| 6 | Coinbase AgentKit wallet | ❌ |
| 7 | dealwork.ai API | ❌ |
| 8 | HKUDS/AI-Trader paper trading | ❌ |
| 9 | Google Maps scraper | ❌ |
| 10 | Cron joby (nightly-compress, insight, war-room) | ❌ |
| 11 | Paper → LIVE switch | ❌ |
| 12 | AEO dla Car Rent | ❌ |
| 13 | SDR campaign | ❌ |
| 14 | Full autonomy verification | ❌ |

## Zbudowane komponenty:
- ✅ Konfiguracja tierów: `/opt/ares/policies/tier-config.yaml` (Contabo)
- ✅ Budget Intelligence MCP: `/opt/ares/mcp-servers/budget-intelligence.py` (Contabo)
- ✅ Cron weekly model refresh: `/opt/ares/cron/weekly-model-refresh.sh` (lokalnie, do deployu)
- ✅ Slideshow ARES: `/tmp/ares-slideshow.html` (lokalnie)
- ✅ Diagram Excalidraw: online
- ✅ 22 pliki KB: `/root/03-Knowledge/autonomous-agent-research/`
- ✅ Excildraw diagram: `https://excalidraw.com/#json=79_9Nyyj6R2v9nh1GliXh,_qy0x3Wy_NF1i_BtQMDDNQ`

## Kluczowe Pliki KB
- `architecture/ares-ultimate-plan.md` — ostateczna architektura
- `architecture/contabo-analysis.md` — analiza Contabo
- `architecture/system-design.md` — projekt systemu
- `architecture/agent-roster.md` — 9 agent YAML
- `architecture/deployment-roadmap.md` — roadmapa
- `architecture/ares-diagram.excalidraw` — diagram
- `platforms/agent-native-platforms.md` — 12+ platform
- `platforms/payment-infrastructure.md` — x402, Crossmint, AgentKit
- `platforms/traditional-platforms-tos.md` — Upwork/Fiverr analiza
- `platforms/additional-channels.md` — DeFi, SMB, content
- `technical/framework-comparison.md` — Omnigent vs inni
- `technical/cost-optimization.md` — ClawRouter, routing
- `technical/omnigent-installation.md` — instalacja Omnigent
- `technical/x402-protocol.md` — x402 implementacja
- `technical/platform-apis.md` — dealwork, Etsy, Printify
- `technical/mcp-protocols.md` — MCP, A2A, ACP
- `technical/agent-identity-reputation.md` — ERC-8004, on-chain
- `technical/tax-legal-implications.md` — podatki, legal
- `case-studies/felix-openclaw.md` — Felix case
- `case-studies/proven-earnings.md` — 12 case studies
- `case-studies/prediction-markets.md` — Polymarket
- `case-studies/failure-modes.md` — 7 failure modes
- `case-studies/contabo-awa-analysis.md` — stary Belfort AWA

## Koszty OmniRoute (dotychczasowe):
- Total: $29.40
- opencode-go: $22.17 (4913 req, 715.7M tok)
- antigravity: $6.89 (128 req, 6.5M tok)
- openrouter: $0.27

## Uwagi Końcowe
- Nie pisać nic od zera — korzystać z gotowych komponentów i łączyć je w ARES
- Kamil nie lubi BigTech hype (Anthropic, Google). Preferuje chińskie modele (GLM, Qwen, DeepSeek) za lepsze value.
- ARES zaczyna za FREE i sam zarabia na lepsze modele
- Paper trading przed LIVE USDC na Polymarket (2 tygodnie)
- Council debata przed każdą decyzją >$10
