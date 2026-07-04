# Framework Comparison — Omnigent vs OpenClaw vs LangGraph vs CrewAI vs AutoGen

## Quick Decision Matrix

| Framework | Stars | Best For | Language | License | Key Feature |
|-----------|-------|----------|----------|---------|-------------|
| **OpenClaw** | 280K+ | Personal autonomous agent, local-first | TypeScript | MIT | Heartbeat, memory, messaging integration |
| **Omnigent** | 6.1K | Meta-harness, multi-vendor orchestration | Python | Apache 2.0 | Swap harnesses, policies, sandbox |
| **LangGraph** | 24.8K | Stateful graphs, production control | Python/TS | MIT | Directed graphs, conditional branching |
| **CrewAI** | — | Quick agent workflows, role-based | Python | — | Role-playing, simple setup |
| **AutoGen** | — | Conversation-driven, multi-agent | Python | — | Negotiation, conversational design |
| **Mastra** | — | TypeScript-first agents | TS | — | Python alternative |
| **n8n** | — | No-code/low-code automation | TS | — | Visual workflow builder |
| **SwarmClaw** | — | Agent swarms, self-hosted | TS | — | Heartbeats, delegation, 23+ LLM providers |

---

## OpenClaw — The Autonomous Agent Standard

**Created by:** Peter Steinberger (@steipete)
**History:** Clawdbot → Moltbot → OpenClaw (Nov 2025)
**Stars:** 280,000+ (most popular AI agent framework)

### Architecture
- **Local-first:** Runs on your own hardware (Mac Mini, Mac Studio, small clusters)
- **Messaging-native:** Accessible via WhatsApp, Telegram, Discord, 12+ platforms
- **Heartbeat:** Proactivity system — agent initiates tasks on schedule
- **Memory:** Vector embeddings in SQLite, local Ollama models (328MB embeddinggemma)
- **Skills:** Custom capabilities ("claws") — extensible
- **24/7 operation:** Dedicated hardware, no cloud dependency

### Key Strengths
- Massive community (280K stars)
- Proven in production (Felix: $260K+ revenue)
- Local-first = privacy + no cloud costs
- Messaging integration = natural human-agent communication
- Heartbeat = true autonomy (not just reactive)

### Key Weaknesses
- Single-agent focus (multi-agent is bolted on)
- Memory fragmentation across agents
- Session isolation issues (GitHub issue #27340)
- Heartbeat model override bugs (#22133)
- TypeScript-only

### Best For
- Personal autonomous agents
- "Agent CEO" pattern (like Felix)
- Local-first privacy requirements
- Messaging-driven interaction

---

## Omnigent — The Meta-Harness

**Created by:** Databricks (Matei Zaharia)
**Stars:** 6,100+
**Status:** Alpha (breaking changes expected)

### Architecture
- **Meta-harness:** Orchestration layer OVER Claude Code, Codex, OpenCode, Cursor, Hermes, Pi
- **Agent YAML:** Short config files define agents, sub-agents, policies, sandbox
- **Contextual policies:** ALLOW/ASK/DENY with stateful context tracking
- **Sandbox execution:** bubblewrap (Linux), seatbelt (macOS), Job Objects (Windows)
- **Session persistence:** Across terminal, browser, phone, desktop app
- **Multi-agent:** Mix vendors in same session, cross-vendor review

### Key Strengths
- Swap harnesses without rewriting (one-line YAML change)
- Policy enforcement (cost_budget, blast_radius, spawn_bounds)
- Cross-vendor review (implementer from vendor A, reviewer from B)
- Polly pattern: orchestrator writes no code, delegates everything
- Docker isolation, web UI, mobile access

### Key Weaknesses
- Alpha status (breaking changes)
- Requires all harness CLIs on PATH
- Complex setup (Python 3.12+, Node 22, tmux, bubblewrap)
- Overkill for single-agent use

### Best For
- Multi-agent coding orchestration
- Cross-vendor quality assurance
- Policy-governed autonomous systems
- Teams mixing multiple AI vendors

---

## SwarmClaw — Open-Source Agent Swarms

**Repo:** github.com/swarmclawai/swarmclaw

### Architecture
- Self-hosted AI agent runtime
- Multi-agent framework for autonomous swarms
- Orchestrates agent swarms with delegation
- Durable memory across agents
- 23+ LLM providers supported
- MCP tools integration
- Visualizes agent teams via org chart

### Key Features
- **Heartbeats:** Agents run on their own schedule
- **Delegation:** Agents delegate to sub-agents
- **Runtime skills:** Loadable capabilities
- **Reviewed actions:** Governance layer
- **Schedules:** Cron-like task scheduling

### Best For
- "Space station" architecture (multiple specialized agents)
- Self-hosted alternative to Omnigent
- Swarm coordination without cloud

---

## LangGraph — Stateful Agent Graphs

**Created by:** LangChain team
**Stars:** 24,800+

### Architecture
- Models workflows as **directed graphs**
- Nodes = steps (LLM call, tool use, human input)
- Edges = flow between steps (including conditional branching)
- Precise control over agent behavior

### Key Strengths
- Full control over every decision
- Complex branching logic
- Production-ready stateful workflows
- Self-correcting autonomous agents

### Key Weaknesses
- Steeper learning curve
- Graph-based thinking required
- More code than declarative frameworks

### Best For
- Complex multi-step workflows
- Production systems requiring reliability
- Self-correcting agents
- Fine-grained control

---

## CrewAI — Role-Based Agents

### Architecture
- Role-playing agents with defined personas
- Built-in tools (web search, file ops, API calls)
- Tool delegation between agents
- Natural specialization

### Key Strengths
- Lowest barrier to entry
- Quick to build workflows
- Content creation pipelines, research workflows

### Key Weaknesses
- Abstractions too opaque for fine-grained control
- Not ideal for mission-critical systems

### Best For
- Content creation pipelines
- Research workflows
- Business analysis tasks
- Teams without deep infrastructure expertise

---

## Decision Framework for Our System

### Recommendation: Hybrid (Omnigent + OpenClaw patterns)

**Why hybrid:**
1. **Omnigent** provides: meta-harness, policies, sandbox, cross-vendor review, Polly pattern
2. **OpenClaw patterns** provide: heartbeat/proactivity, 3-layer memory, soul file, nightly self-improvement
3. **SwarmClaw** concepts: agent swarm coordination, delegation, org chart

**Architecture mapping:**
- Omnigent = orchestration layer (Docker, policies, sub-agent dispatch)
- OpenClaw patterns = memory architecture, soul file, heartbeat loop
- x402 = autonomous payment infrastructure
- dealwork.ai API = primary earning channel

### What NOT to use
- **n8n/Make.com:** Good for simple automation but not true AI agents (no function calling on demand)
- **CrewAI:** Too opaque for the level of control needed
- **LangGraph:** Good but Omnigent already provides graph-like orchestration with policies

### Alternative: Pure OpenClaw + SwarmClaw
If Omnigent's alpha status is a concern:
- OpenClaw for core agent runtime
- SwarmClaw for multi-agent coordination
- Manual policy enforcement (cost tracking, blast radius checks)
- Simpler setup, less governance

### Alternative: Pure Omnigent
If you want maximum governance:
- Omnigent for everything (orchestration + policies + sandbox)
- Custom YAML agents based on Polly pattern
- Built-in cost_budget, blast_radius, spawn_bounds policies
- Docker isolation
