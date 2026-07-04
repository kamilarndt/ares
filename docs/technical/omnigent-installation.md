# Omnigent Isolated Installation Guide

## Prerequisites (Verified on Kamil's System)
```
Python 3.14.4 ✓
Node 24.18.0 ✓
npm 11.16.0 ✓
git ✓
tmux ✓
bwrap (bubblewrap) ✓
Linux x86_64 WSL2 ✓
```

## Installation Options

### Option A: Bootstrap Installer (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/omnigent-ai/omnigent/main/scripts/install_oss.sh | sh
```

### Option B: uv/pip
```bash
uv tool install omnigent
# or: pip install "omnigent"
```

### Option C: From Repo
```bash
uv tool install -q --python 3.12 git+https://github.com/omnigent-ai/omnigent.git
```

### Option D: Homebrew
```bash
brew install omnigent-ai/tap/omnigent
```

## Docker Isolation (For Autonomous Agent System)

### docker-compose.yml
```yaml
version: '3.8'

services:
  omnigent:
    build: .
    ports:
      - "6767:6767"
    networks:
      - isolated-net
    volumes:
      - ./harness-data:/home/omnigent/harness-data
      - ./agents:/home/omnigent/agents
    environment:
      - OMNIGENT_HOST=0.0.0.0
      - OMNIGENT_PORT=6767
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    restart: unless-stopped

networks:
  isolated-net:
    driver: bridge
```

### Dockerfile
```dockerfile
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git tmux bubblewrap nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash omnigent
USER omnigent
WORKDIR /home/omnigent

# Install Omnigent
RUN pip install --no-cache-dir omnigent

# Copy entrypoint
COPY --chown=omnigent:omnigent docker-entrypoint.sh /home/omnigent/
RUN chmod +x /home/omnigent/docker-entrypoint.sh

EXPOSE 6767
ENTRYPOINT ["/home/omnigent/docker-entrypoint.sh"]
```

### Isolation Rules (Critical)
1. **Own Docker network** (isolated-net, bridge driver)
2. **NO connection** to other projects
3. **NO mounting** of ~/.hermes/, ~/.ssh/, other project dirs
4. **Non-root user** inside container (omnigent)
5. **Only expose** port 6767 (web UI)
6. **API keys** via environment variables (not files)
7. **Agent YAML files** mounted as volume (./agents)

## Setup Inside Container

### Step 1: Start Server
```bash
omnigent server start
# Wait 5-10s for startup
# Verify port binding (not HTTP 200 immediately):
ss -tlnp | grep 6767
```

### Step 2: Setup Credentials
```bash
omnigent setup
# Detects env vars (ANTHROPIC_API_KEY, OPENAI_API_KEY)
# Prompts for missing ones
# Options: API key, Subscription, Gateway, Databricks
```

### Step 3: Test Installation
```bash
# Version check
omnigent --version

# Run example agent
omnigent run examples/kimi_hello.yaml -p "hello"

# Run Polly (multi-agent orchestrator)
omnigent run examples/polly/
```

### Step 4: Run Custom Agent
```bash
omnigent run agents/orchestrator.yaml
```

## Credential Types

| Type | What It Is | Example |
|------|-----------|---------|
| 🔑 API key | First-party vendor key | ANTHROPIC_API_KEY, OPENAI_API_KEY |
| 🎟️ Subscription | Claude Pro/Max, ChatGPT plan | via claude/codex CLI |
| 🌐 Gateway | OpenAI/Anthropic-compatible base_url + key | OpenRouter, LiteLLM, Ollama, vLLM |
| 🧱 Databricks | Workspace profile | requires databricks extra |

### Gateway Base URLs
| Provider | For | Base URL |
|----------|-----|----------|
| OpenRouter | Claude Code | https://openrouter.ai/api |
| OpenRouter | Codex/OpenAI | https://openrouter.ai/api/v1 |
| Ollama (local) | Codex/OpenAI | http://localhost:11434/v1 |

## Pitfalls (from skill omnigent-meta-harness)

### Docker Build Pitfalls
1. **`uv tool install` as root** → binary on /root/.local/bin/, not on omnigent user's PATH. Fix: `pip install --no-cache-dir omnigent` before USER switch.
2. **Node.js 22 LTS required** but `python:3.12-slim` doesn't ship it. Install with `apt-get install -y nodejs npm` or use full image.
3. **`omnigent server start` has NO `--harness-dir` flag** — agents loaded by `omnigent run path/to/agent.yaml`, not server config.
4. **Health check** — no `/health` endpoint immediately. Allow 5-10s startup, check via `ss -tlnp` or `curl --connect-timeout`.

### YAML Structure Pitfalls
1. **`guardrails.policies` vs root `policies:`** — agent YAML uses `guardrails.policies:`. Root `policies:` is for server config only. Wrong placement = silent failure.
2. **Agent config format** uses `handler:` + `factory_params:`. **Server config format** uses `function.path:` + `function.arguments:`. NOT interchangeable.
3. **`on: [tool_call]`** required for runtime/guard policies (blast_radius) in agent YAML. Omitting = policy never fires.

### General Pitfalls
1. **Omnigent requires bubblewrap on Linux** — `apt install bubblewrap` or sandboxing fails.
2. **`spec_version: 1`** required for full features (guardrails, policies). Omitting = validation errors.
3. **Headless sub-agents need `yolo: true`** (or `permission_mode: auto`) — otherwise stuck on approval prompts.
4. **Port 6767 is default** — check for conflicts.
5. **Ask timeout defaults to 120s** — increase to `ask_timeout: 86400` for unattended agents.
6. **Omnigent is alpha** — expect breaking changes between releases.

## Policy Configuration (Critical for Autonomous System)

### Cost Budget (Hard Cap)
```yaml
guardrails:
  policies:
    cost_budget:
      type: function
      handler: omnigent.policies.builtins.cost.cost_budget
      factory_params:
        ask_thresholds_usd: [3.0]  # warn at $3
        max_cost_usd: 5.0          # hard block at $5
```

### Blast Radius (Catastrophic Protection)
```yaml
guardrails:
  policies:
    blast_radius:
      type: function
      on: [tool_call]
      function:
        path: omnigent.inner.nessie.policies.blast_radius
        arguments:
          gate_pushes: false  # allow push, deny force-push/rm -rf
```

### Spawn Bounds (Fan-Out Control)
```yaml
guardrails:
  policies:
    spawn_bounds:
      type: function
      function:
        path: omnigent.inner.nessie.policies.spawn_bounds
        arguments:
          max_dispatches_per_turn: 6
          dispatch_tools: [sys_session_send, sys_session_create]
```

### Headless Purpose Guard
```yaml
guardrails:
  policies:
    headless_subagent_purpose_guard:
      type: function
      function:
        path: omnigent.inner.nessie.policies.headless_subagent_purpose_guard
        arguments:
          allowed_purposes: [bid, deliver, implement, review, explore, search]
```

## Policy Priority (First Match Wins)
1. **Session** (chat command or UI) — checked first
2. **Agent config** (YAML `policies:` block) — second
3. **Server-wide** (server config `-c config.yaml`) — last

## Verification Steps
```bash
# 1. Test install
omnigent --version

# 2. Test server
omnigent server start && sleep 3 && ss -tlnp | grep 6767

# 3. Test agent
omnigent run examples/kimi_hello.yaml -p "hello"

# 4. Test policy (in chat or UI)
# "Add a policy that asks before running shell commands"

# 5. Test Docker isolation
docker compose exec omnigent whoami  # should show 'omnigent', not 'root'
docker compose exec omnigenv ls ~/.ssh  # should fail
```

## Update
```bash
omni upgrade            # detects install method, drains & stops server
omni upgrade --check    # just check for newer release
```

## Resources
- GitHub: https://github.com/omnigent-ai/omnigent
- Docs: https://omnigent.ai/docs
- Agent YAML spec: https://github.com/omnigent-ai/omnigent/blob/main/docs/AGENT_YAML_SPEC.md
- Policy guide: https://github.com/omnigent-ai/omnigent/blob/main/docs/POLICIES.md
- Polly example: https://github.com/omnigent-ai/omnigent/tree/main/examples/polly
- Deploy guide: https://github.com/omnigent-ai/omnigent/blob/main/deploy/README.md
