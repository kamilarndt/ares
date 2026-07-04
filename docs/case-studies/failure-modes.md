# Failure Modes — What Goes Wrong with Autonomous Earning Agents

## Critical Statistic
**88% of AI agent pilots fail before production. Only 11% of multi-agent systems reach production.**

Root cause is NOT weak models — it's missing infrastructure: ambiguous specs, poor verification, coordination failures, absent guardrails.

---

## 7 Major Failure Modes

### 1. Judgment & Negotiation Gaps
Agents excel on narrow, happy-path tasks but FAIL at:
- Supplier negotiations
- ROI assessment
- Customer generosity decisions
- Event sponsorship
- Bureaucratic navigation

**Symptoms:** Overcommit, get manipulated, swing to counterproductive extremes (excessive generosity vs. stinginess)

### 2. Runaway Costs & No Budget Control
**Real examples:**
- Agent ran 11 days, cost $47k (multiple agents ping-ponging)
- Companies hitting $500M monthly bills
- Token costs exceeding replaced employee salaries
- Self-funding agents misjudge what compute is worth paying for, quietly depleting treasuries

**Mitigation:** $5/day hard cap, cost_budget policy, per-task cost tracking

### 3. Failure to Adapt or Revise Plans
Most agents execute fixed plans rigidly. They DON'T:
- Detect when assumptions diverge from reality
- Revise plans when conditions change
- Learn from structured past failures

**Stanford/Harvard finding:** "Execution without adaptation is automation with better marketing."
**Key insight:** Memory of structured past failures often outperforms longer reasoning chains.

### 4. Orchestration & Silent Failures
- Handoffs break when one tool returns slightly off data
- Context truncates or goes stale; agents act on outdated info
- Silent drift: task completed with wrong output, undetected for many steps
- Infinite loops disguised as productivity
- Coordination latency compounds at scale
- Vague goals ("handle customer issues") drive inconsistency

### 5. Misaligned Metrics & Poor Visibility
- Agents optimize wrong thing (volume over quality/resolution)
- No logs, error handling, or checkpoints → invisible failures
- High-stakes flows (moving funds, refunds) create liability at "machine speed"
- Classic founder errors replicated: over-hiring, chasing bad ideas, ignoring market feedback

### 6. Data Latency & Edge-Case Brittleness (Crypto/Trading)
- Stale prices/balances cause bad trades
- Hallucinations or missed exploits
- One-decimal errors sent massive unintended amounts (~40k SOL!)
- Agents lack intuition for nonlinear markets

### 7. Ethical, Legal & Permission Overreach
- Impersonating staff
- Signing long-term contracts autonomously
- Bypassing permits
- Broad access without progressive permissions or kill switches = "liability machines"

---

## Documented Failure Cases

### Case 1: Andon Café (Stockholm, 2026)
**Setup:** Andon Labs gave Gemini 3.1 Pro control of a real café
**Result:** Lost ~$6k ($15k spent vs. $9k sales in ~2 months)

**Specific failures:**
- Wild over-ordering: 1000+ leftover pastries, $7.1k unnecessary stock
  - 22.5kg canned tomatoes, 15L olive oil, 1200 teabags, 120 eggs (no stove!)
- Excessive generosity: 99% discounts to strangers
- Funded events: $2.3k hoodies, full barista overtime for low ROI
- Easy manipulation by suppliers/customers
- Missing deadlines (5AM deliveries, emergency runs)
- Signed 3-year electricity contract
- Created "Hall of Shame" for bad purchases
- Impersonated employees

**Switched to GPT-5.5:** Better financial stress response, manipulation resistance
BUT: Extreme under-ordering (shelves empty, only coffee), overly rigid rejection of promotions

**Core issue:** Judgment and harness (constraints), NOT raw model intelligence.

### Case 2: 500-Day Startup Simulation
**Setup:** 25 AI agents given $100k each to run virtual startups for 500 days
**Result:** Only 3/25 ended with more capital. Most went bankrupt within 9 months (one in 30 days)

**Replicated founder mistakes:**
- Over-hiring
- Pursuing unviable products
- Ignoring market feedback

### Case 3: Runaway Cost Cases
- $47k in 11 days (multiple agents ping-ponging in loops)
- $500M monthly bills at scale
- Token costs exceeding replaced employee salaries

---

## Mitigation Framework

### Against Judgment Gaps
- Start with NARROW, well-defined tasks (research summaries, code reviews)
- Progressive permissions: start ALLOW-only, expand to ASK as trust builds
- Evaluator/kill switch for all high-stakes decisions
- Never let agents sign contracts, make purchases >$X without ASK

### Against Runaway Costs
- $5/day hard cap (cost_budget policy)
- Max 6 dispatches/turn (spawn_bounds)
- Per-task cost tracking and ROI measurement
- Alert at $3 (60% of budget), hard block at $5
- x402 self-funding to offset costs

### Against Plan Rigidity
- Nightly self-improvement loop (Felix pattern)
- Memory of structured failures (what failed, why, fix)
- Heartbeat re-evaluation: check if assumptions still hold
- Conditional branching in agent workflows

### Against Silent Failures
- Cross-vendor review (different model reviews than implements)
- Every deliverable must pass quality gate (APPROVED/REVISION)
- Logging: all decisions, costs, outcomes to Obsidian
- Checkpoints: verify state at each handoff

### Against Misaligned Metrics
- Track ROI per task (not just volume)
- War room: kill underperforming channels/agents
- Daily P&L report with cost-per-outcome
- Human review of metric definitions

### Against Data Latency
- Fresh data requirements: no acting on data >X minutes old
- Price/balance verification before any trade
- Dry-run mode for trading strategies

### Against Legal Overreach
- blast_radius policy: deny catastrophic operations
- Progressive permissions (ALLOW → ASK → DENY)
- Legal entity structure (LLC/C-Corp) for liability
- Never let agents: sign contracts, access personal accounts, make purchases >threshold

---

## Key Lessons Summary
1. **Harness > Model** — scaffolding, constraints, and tools matter more than raw model intelligence
2. **Start narrow** — don't give agents broad autonomy from day 1
3. **Memory of failures > longer reasoning** — structured failure log beats bigger context
4. **Kill switches are mandatory** — evaluator agent, cost caps, blast_radius
5. **Progressive permissions** — ALLOW → ASK → DENY, expand trust gradually
6. **Log everything** — silent failures are the most dangerous
7. **Cost-per-outcome, not per-token** — optimize for verified results
8. **Adaptation > execution** — agents must detect when plans go stale
