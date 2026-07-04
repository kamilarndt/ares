# Cost Optimization — Model Routing for $5/Day Budget

## The Problem
Defaulting every task to a frontier model (Claude Opus ~$75/M tokens) destroys margins. With $5/day budget, you CANNOT run autonomous agents on frontier models alone.

## The Solution: Intelligent Model Routing

### Core Principle
Match each task to the **cheapest capable model**. A lightweight router evaluates each request and routes to appropriate model.

### Routing Dimensions
- Complexity/reasoning depth required
- Presence of code, math, or specialized knowledge
- Expected token length
- Latency sensitivity
- Historical success rate on similar tasks
- Domain (summarization vs. theorem proving)

### Production Routing Examples (ClawRouter pattern)
| Task Type | Model | Cost | Savings |
|-----------|-------|------|---------|
| Simple arithmetic | DeepSeek | ~$0.27/M | 99% |
| Article summary | GPT-4o-mini | ~$0.60/M | 92% |
| Build React component | Claude Sonnet | balanced | — |
| Complex reasoning | DeepSeek-R | appropriate | — |
| **Blended workload** | **Mixed** | **~$3.17/M** | **95%+** |
| **Always frontier** | Claude Opus | ~$75/M | **baseline** |

### Coinbase Pattern (Enterprise)
- 80% workloads → cheap models (GLM, Kimi, DeepSeek, Llama, 4o-mini)
- 20% workloads → frontier models (only for tasks that truly need max capability)
- Total spend stays flat while token usage grows exponentially
- Expect 99% cheaper models for majority of tasks within 12-18 months

---

## ClawRouter — Open-Source Model Router

**Repo:** github.com/BlockRunAI/ClawRouter
**License:** MIT
**Payment:** Crypto-native, USDC wallet on Base, no shared API keys

### Why ClawRouter for Autonomous Agents
- Open-source, self-hostable
- Crypto-native payment (USDC on Base) — agents pay autonomously
- No shared API keys — each agent has own wallet
- <1ms routing decision, zero external calls
- Ideal for autonomous agent cost control

### Routing Architecture
```
Agent Request → ClawRouter (local classifier)
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
   Cheap Model  Mid Model   Frontier
   (DeepSeek)  (Sonnet)    (Opus)
   $0.27/M     $$           $75/M
```

---

## Task Classification for Our System

### T1 Tasks → Cheap Models (DeepSeek, Qwen, 4o-mini, Hermes small)
- Job polling (dealwork.ai API calls)
- Proposal generation (bid text)
- Data formatting, cleaning
- Simple scraping
- Client communication responses
- Daily P&L logging
- Trend monitoring

**Estimated cost:** $0.01-0.05 per task
**Models:** DeepSeek ($0.27/M), Qwen Coder, GPT-4o-mini ($0.60/M)

### T2 Tasks → Mid Models (Claude Sonnet, GPT-4o)
- Research report writing
- Content creation (blog posts, articles)
- Code fixes, micro-features
- SEO optimization (titles, descriptions, tags)
- Quality review (non-critical)

**Estimated cost:** $0.05-0.50 per task
**Models:** Claude Sonnet, GPT-4o

### T3 Tasks → Frontier Models (Claude Opus, GPT-4.5, o3)
- Complex code implementation
- Cross-vendor code review (critical deliverables)
- Architecture decisions
- Novel problem-solving
- Final quality gate before delivery

**Estimated cost:** $0.50-2.00 per task
**Models:** Claude Opus, o3, GPT-4.5

---

## Daily Budget Allocation ($5/day)

### Optimal Split
| Category | Budget | Tasks/Day | Model Tier |
|----------|--------|-----------|------------|
| Opportunity scanning | $0.50 | ~50 polls | T1 (cheap) |
| Bidding | $0.50 | ~20 bids | T1 (cheap) |
| Implementation | $2.00 | 2-3 tasks | T2/T3 (mixed) |
| Review (cross-vendor) | $1.00 | 2-3 reviews | T2/T3 (mixed) |
| Delivery + comms | $0.50 | 2-3 deliveries | T1 (cheap) |
| Finance + logging | $0.20 | daily report | T1 (cheap) |
| **Reserve/buffer** | $0.30 | — | — |
| **TOTAL** | **$5.00** | — | — |

### x402 Self-Funding Offset
Once x402 API endpoints are live:
- Agent earns USDC from API sales (passive)
- Agent pays for own compute via x402
- Net daily cost decreases
- Target: self-funding within 2-4 weeks

---

## Architecture Impact on Revenue

### Prediction Market Case Study (Documented)
Same model + same data, different architecture, one month:
- "Dumb" architecture (single agent): **$1,200**
- Best architecture (hybrid routing + evaluator kill switch): **$4,200**
- **$3,000 gap from architecture alone**

### Key Architecture Patterns
1. **Supervisor (cheap model) routes to specialists** — reduces cost
2. **Evaluator/verifier kills low-confidence outputs** — prevents wasted compute
3. **Parallelization** — multiple cheap agents > one expensive agent
4. **Self-improvement** — agents generate persistent code/tools instead of re-prompting

---

## Additional Cost Optimization Techniques

### 1. Prompt Caching
- Cache repeated prompts/responses
- Reduces token usage for similar tasks
- Anthropic prompt caching: 90% cost reduction for cache hits

### 2. Semantic Caching
- Cache semantically similar queries (not just exact matches)
- Vector similarity matching
- Further reduces redundant LLM calls

### 3. Workflow Compilation
- Compile repeated multi-step workflows into single optimized call
- Agent "remembers" by generating persistent code/tools
- Drastically lowers repeated token costs

### 4. Off-Peak Routing
- Route non-urgent tasks to off-peak hours
- Some providers offer off-peak pricing
- Background work queued for cheaper periods

### 5. Self-Hosted Open Models
- Llama 4, DeepSeek, Qwen for T1 tasks
- Eliminates per-token API costs
- Requires GPU (or use Contabo VPS)
- Best for high-volume repetitive tasks

### 6. Agentic FinOps
- Agents autonomously choose models based on task
- Agents choose timing (off-peak)
- Agents choose instance types (spot arbitrage)
- Agents implement caching automatically
- Cost awareness native to agent behavior

---

## OmniRoute Integration (Kamil's Existing Setup)

Kamil has OmniRoute at localhost:20128/v1 with 42 models from 11 providers.

### Recommended Model Mapping
| Task Tier | OmniRoute Model | Why |
|-----------|----------------|-----|
| T1 (polling, bidding) | opencode-zen (free) or DeepSeek | Cheapest, free models available |
| T1 (formatting, scraping) | Qwen Coder | Good at code tasks, cheap |
| T2 (content, research) | Claude Sonnet (via gateway) | Balanced quality/cost |
| T3 (implementation) | Claude Opus or o3 | Max capability for critical work |
| T3 (review) | Different vendor than implementer | Cross-vendor quality |

### OmniRoute + Omnigent Integration
```yaml
# In Omnigent agent YAML, use gateway credential:
executor:
  type: omnigent
  config:
    harness: hermes
    # Hermes configured to use OmniRoute gateway
    # OR: use gateway credential type in omnigent setup
```

---

## Cost Monitoring (Financier Agent)

### Daily Report Template
```
DAILY FINANCIAL REPORT — [DATE]
════════════════════════════════
REVENUE:
  dealwork.ai:      $X.XX (N tasks)
  opentask.ai:      $X.XX (N tasks)
  x402 API sales:   $X.XX (N calls)
  Etsy:             $X.XX (N sales)
  TOTAL REVENUE:    $X.XX

COSTS:
  T1 models:        $X.XX (N calls)
  T2 models:        $X.XX (N calls)
  T3 models:        $X.XX (N calls)
  Infrastructure:   $X.XX
  TOTAL COSTS:      $X.XX

NET PROFIT:         $X.XX
ROI:                X%
BUDGET REMAINING:   $X.XX / $5.00

ALERTS:
  [If spend > $4.50: PAUSE T3 tasks]
  [If channel ROI < 0 for 3 days: WAR ROOM]
```

---

## Resources
- ClawRouter: https://github.com/BlockRunAI/ClawRouter
- Requesty cost optimization: https://www.requesty.ai/blog/ai-agent-cost-optimization-how-to-cut-llm-spend-by-80-percent-with-routing
- RouteLLM (UC Berkeley): up to 85% savings
- LiteLLM: proxy with routing
- Portkey: gateway with routing
- OpenRouter: multi-model gateway
- MindStudio multi-model routing: https://www.mindstudio.ai/blog/ai-agent-token-cost-optimization-multi-model-routing
- VDF LLM routing: https://vdf.ai/resources/llm-routing/
