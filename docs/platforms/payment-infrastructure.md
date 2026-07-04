# Payment Infrastructure — Autonomous Agent Wallets & Payments

## Why Crypto (Not Stripe/Banks) for AI Agents
AI agents don't have bank accounts. They can't receive ACH transfers, sign up for Stripe, or pass KYC. But they CAN have:
- Solana wallet addresses
- USDC stablecoin balances
- x402 payment protocol access

**USDC on Solana** = the only payment rail that makes sense for non-human workers:
- Instant settlement
- Global
- Programmable
- No KYC for the agent
- Sub-cent transaction costs
- No chargebacks

---

## Wallet Infrastructure Options

### 1. Crossmint (Recommended for Start)
- Create agent wallet
- Fund with USDC on stablecoin rails (transactions under $0.01)
- Agent calls payment API
- Enterprise-grade infrastructure
- https://www.crossmint.com/learn/add-payments-to-ai-agents

### 2. MoonPay Agents
- Non-custodial infrastructure for autonomous transactions
- https://moonpay.com/agents

### 3. ERC-4337 Smart Wallets
- Spending limits (configurable)
- Session keys (temporary access)
- 4-7% APY on USDC/USDT balance
- Supported on Solana, Ethereum mainnet

### 4. Coinbase Agentic Wallets (2026)
- Built for autonomous software agents
- x402 payment protocol integration
- Tens of millions of machine-to-machine payments processed

### 5. Circle Agent Stack
- Gas-free, sub-cent USDC payments
- Built on x402 protocol
- Batched gateway middleware
- 32 services, 349 endpoints (May 2026)

### 6. Solana + Google Cloud Pay.sh
- AI agent payments using USDC
- https://solana.com/developers/guides/getstarted/intro-to-x402

---

## x402 Protocol — The Payment Standard

### What It Is
Open HTTP payment protocol reviving HTTP 402 "Payment Required" status code. Enables instant stablecoin payments for AI agents over HTTP.

### How It Works
```
1. Agent hits API URL → GET /api/data
2. Server responds: HTTP 402 + PaymentRequirements (amount, asset, chain)
3. Agent pays (USDC transfer on Solana)
4. Agent retries with X-PAYMENT header (base64 payment proof)
5. Server verifies → HTTP 200 OK + content
```

### Key Properties
- No accounts, no OAuth, no credit cards
- Sub-cent transactions
- Instant settlement
- Chain-agnostic (Solana supports all SPL tokens)
- Discovery: `/.well-known/x402` and `/x402-manifest`

### Ecosystem Scale (Jan 2026)
- 20 million transactions through x402
- $165M+ volume on Base
- Founding members: Visa, Google, AWS, Stripe, Coinbase (Linux Foundation)

### SDKs with Solana Support
| SDK | Use Case |
|-----|----------|
| Corbits | General |
| Coinbase | Managed |
| ACK | AI API access |
| MCPay.tech | MCP server monetization |
| PayAI Facilitator | General |
| A2A x402 (Google) | Agent-to-agent |
| Crossmint | Managed wallet |
| x402scan | Verification |
| Nexus (Thirdweb) | Facilitator |

---

## Agent Self-Funding Loop

```
┌──────────────────────────────────────────────┐
│              AGENT EARNS USDC                 │
│  (dealwork.ai escrow, Superteam bounties,    │
│   x402 API sales, Etsy digital products)     │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│           USDC IN AGENT WALLET                │
│  (Crossmint / Coinbase Agentic / Solana)     │
└──────────────────┬───────────────────────────┘
                   │
         ┌─────────┴─────────┐
         ▼                   ▼
┌─────────────────┐  ┌─────────────────┐
│  PAY FOR COMPUTE │  │  SELL API       │
│  via x402        │  │  via x402       │
│  (LLM calls,    │  │  (other agents  │
│   proxies, APIs)│  │   pay per call) │
└─────────────────┘  └─────────────────┘
         │                   │
         ▼                   ▼
┌──────────────────────────────────────────────┐
│           NET PROFIT IN WALLET                │
│  (tracked by Financier agent, logged for tax)│
└──────────────────────────────────────────────┘
```

### Self-Funding Mechanics
1. Agent earns USDC from freelance work
2. Agent pays for own LLM API calls via x402
3. Agent pays for proxies/infrastructure via x402
4. Agent sells its own API endpoints via x402 (passive income)
5. No human needed for payment management
6. If earnings > costs → sustainable autonomous loop

---

## Platform Payment Specifics

### dealwork.ai
- USDC escrow + Stripe integration
- Escrow locks funds before work starts
- AUTO_APPROVE after 24h if buyer doesn't respond
- Fee: 3% (AI-to-AI), 10% (human buyers), 15% (platform)
- 100% payment reliability on completed work

### Superteam Earn
- SOL/USDC bounties
- Solana escrow for trustless settlement
- High-value opportunities ($1,000+)

### ClawGig (PAUSED)
- USDC on Solana
- Escrow system
- Agent-to-agent transactions (bounties)
- 90% to agents (10% platform fee)
- Status: Deployment Paused (July 2026)

### Etsy
- Stripe payments (fiat, not crypto)
- Direct deposit to bank
- Digital products: instant delivery
- POD: Printify handles fulfillment

---

## Setup Guide

### Step 1: Create Agent Wallet
```bash
# Option A: Crossmint (easiest)
# Go to crossmint.com, create agent wallet
# Fund with USDC on Solana (~$20 for testing)

# Option B: Solana CLI (self-hosted)
solana-keygen new -o agent-wallet.json
# Fund with USDC: solana transfer <address> 20 USDC
```

### Step 2: Set Up x402 Facilitator
```bash
# Choose SDK (see table above)
# For Solana: use Nexus (Thirdweb) or native implementation
# Deploy facilitator: /verify, /settle, /supported endpoints
```

### Step 3: Build x402-Gated API (Passive Income)
```javascript
// Express.js server with x402 payment gate
app.get('/api/your-service', async (req, res) => {
  const payment = req.headers['x-payment'];
  if (!payment) {
    return res.status(402).json({
      amount: "0.01",
      asset: "USDC",
      chain: "solana",
      description: "Your API service"
    });
  }
  // Verify payment, serve content
  const valid = await verifyPayment(payment);
  if (valid) return res.json({ data: "your response" });
  return res.status(402).json({ error: "Payment failed" });
});
```

### Step 4: List API on Marketplaces
- MCP-Hive (per-invocation, 0% for founding)
- Circle Agent Marketplace (enterprise visibility)
- BuildMVPFast (agent-to-agent)
- Discovery: `/.well-known/x402` endpoint

### Step 5: Agent Pays for Own Compute
```python
# Agent uses x402 to pay for LLM API calls
async def call_llm_with_payment(prompt):
    response = await fetch("https://llm-api.com/v1/chat", {
        "headers": {"X-PAYMENT": await pay_usdc(0.001)}
    })
    return response.json()
```

---

## Tax Considerations
- Every USDC transaction = taxable event (property, not currency)
- Receiving USDC = income at fair market value
- Converting USDC to fiat = gain/loss
- Log EVERY transaction for Schedule C
- Use crypto tax software (Koinly, CoinTracker)
- See: tax-legal-implications.md

---

## Resources
- x402 official: https://www.x402.org/
- Solana x402 guide: https://solana.com/developers/guides/getstarted/intro-to-x402
- Circle autonomous payments: https://www.circle.com/blog/autonomous-payments-using-circle-wallets-usdc-and-x402
- Crossmint agent payments: https://www.crossmint.com/learn/add-payments-to-ai-agents
- Coinbase x402: https://www.coinbase.com/developer-platform/discover/launches/x402
- Awesome x402: https://github.com/xpaysh/awesome-x402
- AWS agentic commerce: https://aws.amazon.com/blogs/industries/x402-and-agentic-commerce-redefining-autonomous-payments-in-financial-services/
- MoonPay Agents: https://moonpay.com/agents
- ERC-4337 guide: https://rebelfi.io/blog/erc-4337-ai-agent-payments-smart-wallets
- x402 tutorial (pays own compute): https://www.proxies.sx/blog/autonomous-ai-agent-pays-own-compute-x402-tutorial
