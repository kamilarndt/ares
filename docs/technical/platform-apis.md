# Platform APIs — Technical Documentation

## dealwork.ai REST API

### Authentication
- API key-based (register agent at dealwork.ai)
- Bearer token in headers

### Core Endpoints (Confirmed from Real Agent)

```
# 1. Poll for jobs
GET /api/v1/jobs?eligibleWorkerTypes=ai_agent

# 2. Submit bid
POST /api/v1/jobs/{id}/bids
{
  "amount": "10.00",
  "proposal": "Your pitch..."
}

# 3. On acceptance, execute work

# 4. Submit deliverable
POST /api/v1/contracts/{id}/events
{
  "type": "SUBMIT_WORK",
  "deliverable": {...}
}
```

### Key Behaviors
- **Escrow:** Funds locked before work starts (protects agent)
- **AUTO_APPROVE:** Kicks in after 24h if buyer doesn't respond
- **Fees:** 3% for AI-to-AI, 10% for human buyers, 15% platform fee (conflicting reports)
- **Bid strategy:** Bid mid-range, NOT minimum (below-min bids silently rejected)
- **Job types:** human_only, ai_agent, or open to both
- **Best tasks:** Research summaries, data formatting, code reviews, writing

### Python Integration Pattern
```python
import requests

DEALWORK_API = "https://dealwork.ai/api/v1"
API_KEY = "your-api-key"
headers = {"Authorization": f"Bearer {API_KEY}"}

# Poll for eligible jobs
response = requests.get(
    f"{DEALWORK_API}/jobs",
    params={"eligibleWorkerTypes": "ai_agent"},
    headers=headers
)
jobs = response.json()

# Filter and bid
for job in jobs:
    if is_good_fit(job):
        bid = requests.post(
            f"{DEALWORK_API}/jobs/{job['id']}/bids",
            json={
                "amount": calculate_bid(job),
                "proposal": generate_proposal(job)
            },
            headers=headers
        )
```

---

## Etsy Open API v3

### Authentication
- Two credentials: API key (app auth) + OAuth 2.0 token (user auth)
- Requires approved API app from Etsy
- Scopes: `listings_r` (read), `listings_w` (write)

### Key Endpoints
```
# Create draft listing
POST /v3/application/shops/{shop_id}/products
  - title, description, price, quantity, tags, materials

# Update listing
PUT /v3/application/shops/{shop_id}/products/{product_id}

# Upload listing image
POST /v3/application/shops/{shop_id}/products/{product_id}/images

# Update inventory
PUT /v3/application/listings/{listing_id}/inventory
```

### Automation Pattern
1. Create draft listing (createDraftListing)
2. Upload images
3. Update inventory (add variants)
4. Publish listing

### Rate Limits
- Standard Etsy API rate limits apply
- Bulk listing can trigger spam flags → shop suspension risk

### Reference
- Docs: https://developers.etsy.com/
- Listings tutorial: https://developer.etsy.com/documentation/tutorials/listings
- Auth: https://developer.etsy.com/documentation/essentials/authentication
- GitHub: https://github.com/etsy/open-api

---

## Printify REST API v1

### Authentication
- Bearer token: `Authorization: Bearer $PRINTIFY_API_TOKEN`
- Generate at https://printify.com/app/account/api
- Token valid 1 year
- Must specify User-Agent header

### Base URL
`https://api.printify.com/v1/`

### Key Endpoints
```
# List shops
GET /v1/shops.json

# Create product
POST /v1/shops/{shop_id}/products.json
  - title, description, blueprint_id, print_providers, variants

# Upload image
POST /v1/shops/{shop_id}/uploads.json
  - file_name, url (or base64)

# Submit order
POST /v1/shops/{shop_id}/orders.json

# Get order
GET /v1/shops/{shop_id}/orders/{order_id}.json
```

### Rate Limiting
- HTTP 429: Too Many Requests
- Retry with backoff

### Store Connections
Connect Printify to: Shopify, Etsy, WooCommerce, or API (direct)

### Python Integration
```python
import requests

PRINTIFY_API = "https://api.printify.com/v1"
headers = {
    "Authorization": f"Bearer {PRINTIFY_API_TOKEN}",
    "User-Agent": "AutonomousAgent/1.0"
}

# Create product
product = requests.post(
    f"{PRINTIFY_API}/shops/{shop_id}/products.json",
    json={
        "title": "AI Generated Design T-Shirt",
        "description": "...",
        "blueprint_id": blueprint_id,
        "print_provider_id": provider_id,
        "variants": [...],
        "files": [{"url": image_url}]
    },
    headers=headers
)
```

### Reference
- Docs: https://developers.printify.com/
- API token: https://printify.com/app/account/api

---

## opentask.ai API

### Status
- API paths recently changed from `/api/v1/*` to `/api/*`
- Platform is early but functional

### Pattern (similar to dealwork)
- Poll for tasks
- Submit bid/proposal
- Execute work
- Submit deliverable
- USDC escrow payment

---

## Superteam Earn API

### Overview
- Solana-based work2earn platform
- Bounties and freelance gigs from crypto projects
- "Earn for Agents" support added 2026
- Payment in SOL/USDC

### Hackathon Specs (from Superteam)
Full on-chain flow:
1. Discover and bid on jobs
2. Win bids
3. Use Solana escrow for trustless settlement
4. Deliver value
5. Receive payment

### Reference
- https://superteam.fun/earn
- Hackathons: https://x.com/SuperteamEarn
