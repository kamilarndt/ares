# x402 Protocol — Technical Implementation Guide

## Overview
x402 is an open HTTP payment protocol that revives the dormant HTTP 402 "Payment Required" status code. It enables instant stablecoin payments for AI agents over HTTP — no accounts, no OAuth, no credit cards.

## Protocol Flow

```
1. Client (AI agent) hits URL → GET /api/data
2. Server responds: HTTP 402 + JSON PaymentRequirements
   {
     "amount": "0.01",
     "asset": "USDC",
     "chain": "solana",
     "description": "Access to crypto signals API"
   }
3. Client pays (submits on-chain transfer)
4. Client retries: GET /api/data + X-PAYMENT header (base64-encoded payment proof)
5. Server verifies/settles (via facilitator or own validation)
6. Server responds: HTTP 200 OK + content
```

## Key Spec Elements
- **PaymentRequirements** — JSON structure describing what's owed (amount, asset, chain)
- **X-PAYMENT header** — base64-encoded payment proof
- **X-PAYMENT-RESPONSE** — optional header on success
- **Facilitator API** — optional: `/verify`, `/settle`, `/supported` endpoints
- **Current scheme:** `exact` (pay a specific amount). `upto` proposed.

## Solana Support
- Chain-agnostic protocol, but Solana supports all SPL tokens
- Available SDKs with Solana support:

| SDK | Type | Solana Support |
|-----|------|----------------|
| Corbits | — | Available |
| Coinbase | Managed | Available |
| ACK | — | Available |
| MCPay.tech | MCP monetization | Available |
| PayAI Facilitator | — | Available |
| A2A x402 (Google) | Agent-to-agent | Available |
| Crossmint | Managed wallet | Available |
| x402scan | Verification | Available |
| Nexus (Thirdweb) | Facilitator | Available |

## Use Cases for Autonomous Agents

### AI & Agent Commerce
- **AI Agent API Access:** Pay per LLM inference, image generation, model API call
- **MCP Server Monetization:** Charge for MCP tools, data sources, agent capabilities
- **Agent-to-Agent Payments:** Autonomous agents transact with each other for services/data
- **Premium AI Tools:** Pay-per-use for specialized AI capabilities

### Self-Funding Loop
1. Agent earns USDC from freelance work (dealwork.ai, etc.)
2. Agent pays for its own compute/API calls via x402
3. Agent sells its own API endpoints via x402 (passive income)
4. No human needed for payment management

## Implementation: Minimal Server (Express.js)

```javascript
const express = require('express');
const app = express();

// Facilitator verifies on-chain payment
async function verifyPayment(paymentHeader, requirements) {
  // Decode base64 payment proof
  // Verify on-chain transfer matches requirements
  // Return true/false
}

app.get('/api/data', async (req, res) => {
  const paymentHeader = req.headers['x-payment'];
  
  if (!paymentHeader) {
    return res.status(402).json({
      amount: "0.01",
      asset: "USDC",
      chain: "solana",
      description: "Access to crypto signals API"
    });
  }
  
  const valid = await verifyPayment(paymentHeader, requirements);
  if (valid) {
    return res.status(200).json({ data: "your API response" });
  }
  
  return res.status(402).json({ error: "Payment verification failed" });
});
```

## Implementation: Minimal Client (Node.js)

```javascript
// Agent client that pays for API access
async function callPaidApi(url) {
  // 1. Hit URL, get 402 + requirements
  let res = await fetch(url);
  if (res.status === 402) {
    const requirements = await res.json();
    
    // 2. Pay (submit USDC transfer on Solana)
    const paymentProof = await submitPayment(requirements);
    
    // 3. Retry with X-PAYMENT header
    res = await fetch(url, {
      headers: { 'X-PAYMENT': Buffer.from(JSON.stringify(paymentProof)).toString('base64') }
    });
    
    if (res.status === 200) {
      return await res.json();
    }
  }
  return null;
}
```

## Pricing Examples (from live x402 endpoints)
- Crypto signals API: $0.001-$0.01 per call
- Cryptobuddy: $0.50 per request
- AIsa API: $0.01-$0.12 per request
- Gloria AI: $0.003 per request

## Discovery Endpoints
- `/.well-known/x402` — standardized discovery
- `/x402-manifest` — alternative discovery endpoint

## Circle Agent Stack (gas-free)
- Circle (USDC issuer) built agent stack on x402
- Gas-free, sub-cent USDC payments for autonomous AI agents
- Batched gateway middleware
- 32 services, 349 endpoints at launch (May 2026)

## Key Ecosystem Facts
- 15M+ transactions processed
- $165M+ volume on Base
- Founding members of x402 Foundation (Linux Foundation): Visa, Google, AWS, Stripe, Coinbase
- AWS AgentCore Payments: agents autonomously discover, authorize, execute x402 micropayments with built-in wallet management

## Resources
- Official: https://www.x402.org/
- Solana guide: https://solana.com/developers/guides/getstarted/intro-to-x402
- Circle autonomous payments: https://www.circle.com/blog/autonomous-payments-using-circle-wallets-usdc-and-x402
- Coinbase launch: https://www.coinbase.com/developer-platform/discover/launches/x402
- Awesome x402: https://github.com/xpaysh/awesome-x402
- AWS agentic commerce: https://aws.amazon.com/blogs/industries/x402-and-agentic-commerce-redefining-autonomous-payments-in-financial-services/
