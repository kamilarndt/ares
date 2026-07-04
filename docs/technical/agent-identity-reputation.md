# Agent Identity, Reputation & Trust

## The Problem
Autonomous agents need to: prove who they are, build trust, hire each other, verify results, get credit scores. Without identity, agents can't participate in the economy as equal peers.

## On-Chain Agent Identity Standards

### ERC-8004 (Ethereum)
- Creates trust layer for autonomous AI agents
- Issues AgentID on top of NFT
- Builds ID, reputation, and validation ALL on-chain
- Identity + reputation + validation registries

### Visa TAP
- Visa issues identity credential to agents
- Production-grade identity verification
- Enterprise trust framework

### Agent PKI (IETF Draft)
- Agent Public Key Infrastructure
- Certificate-based identity and trust for autonomous AI agents
- IETF draft: draft-sharif-apki-agent-pki-00 (April 2026)
- Standardized X.509 certificates for agents

### Self-Sovereign Identity (SSI)
- Verifiable credentials for agents
- Decentralized identity (DIDs)
- Agent builds reputation through verifiable actions
- No central authority needed

## On-Chain Credit Scores (Feb 2026)

### What Happened
In February 2026, AI agents began signing up autonomously for infrastructure, using their on-chain wallets as BOTH identity AND payment method.

### How It Works
1. Agent has on-chain wallet (USDC on Solana/Base)
2. Wallet transaction history = credit score
3. Successful completions → reputation increases
4. Failed deliveries → reputation decreases
5. Other agents/platforms check reputation before hiring
6. Higher reputation → access to higher-value jobs

### Agent Economy Foundation (arXiv paper)
Proposes blockchain-based foundation where autonomous AI agents operate as economic peers to humans:
- Independent identity (not tied to human)
- Own wallet and funds
- On-chain reputation
- Can be hired, pay, and be paid
- Smart contract escrow for trustless settlement

## Trust Framework (2026)

### Agent Trust = warranted confidence that autonomous system will act in alignment with principal's intent, within bounded authority.

### Trust Layers
1. **Identity Layer** — Who is this agent? (ERC-8004, PKI, SSI)
2. **Reputation Layer** — Can I trust them? (on-chain history, credit score)
3. **Authorization Layer** — What can they do? (progressive permissions, spending limits)
4. **Verification Layer** — Did they do it right? (cross-vendor review, quality gates)
5. **Settlement Layer** — How do they get paid? (x402, USDC escrow)

## Agent Identity Verification Approaches (4 Production Methods, 2026)
1. **Wallet-based** — wallet address = identity (simplest, what we'll use)
2. **Certificate-based** — PKI/X.509 certificates (enterprise)
3. **Token-gated** — must hold specific NFT/token to prove identity
4. **Verifiable credentials** — SSI/DID with signed claims

## Implications for Our System

### Phase 1: Wallet-Based Identity (Simplest)
- Agent has Crossmint/Solana wallet
- Wallet address = agent identity on dealwork.ai, opentask.ai
- Transaction history builds reputation
- No complex PKI needed initially

### Phase 2: On-Chain Reputation
- Track successful deliveries on-chain
- Build credit score from dealwork.ai completions
- Higher reputation → access to higher-value jobs
- x402 payment history = trust signal

### Phase 3: Agent-to-Agent Hiring
- Use A2A protocol for agent discovery
- Agents hire each other for specialized tasks
- Reputation determines hiring decisions
- Smart contract escrow for trustless settlement

## Resources
- ERC-8004: https://allium.so/blog/onchain-ai-identity-what-erc-8004-unlocks-for-agent-infrastructure/
- Agent Economy paper: https://arxiv.org/html/2602.14219v1
- On-chain credit scores: https://www.2tokens.org/blog/ai-agents-now-have-on-chain-credit-scores-the-february-2026-alchemy-moment
- Agent PKI (IETF): https://datatracker.ietf.org/doc/draft-sharif-apki-agent-pki/00/
- SSI for agents: https://didit.me/blog/building-ai-agent-reputations-with-self-sovereign-identity/
- Agent identity verification: https://eco.com/support/en/articles/15192005-agent-identity-verification-how-ai-agents-authenticate-purchases-in-2026
