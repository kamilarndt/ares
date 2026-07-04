#!/bin/bash
# ARES Command Center — Multi-agent status grid
# Pings all 12 agents in sequence, shows health.

API_URL="http://localhost:20128/v1/chat/completions"
AUTH="Authorization: Bearer sk-42e810ef4042e82f-c42dc9-fa0c1bce"

declare -A MODELS
MODELS=(
  [scout]="auto/best-fast"
  [bidder]="auto/best-chat"
  [implementer]="auto/best-coding"
  [reviewer]="auto/best-reasoning"
  [deliverer]="auto/best-fast"
  [financier]="auto/best-reasoning"
  [sdr-promoter]="auto/best-chat"
  [aeo-architect]="auto/best-coding"
  [prediction-trader]="auto/best-reasoning"
  [council]="auto/best-reasoning"
  [insight-engine]="auto/best-reasoning"
  [war-room]="auto/best-reasoning"
)

AGENTS=(scout bidder implementer reviewer deliverer financier sdr-promoter aeo-architect prediction-trader council insight-engine war-room)

while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════════════════╗"
  echo "║                    ARES — 12-AGENT STATUS GRID                      ║"
  echo "║                    $(date '+%Y-%m-%d %H:%M:%S')                   ║"
  echo "╚══════════════════════════════════════════════════════════════════════╝"
  echo ""
  echo "  Harness: Pi(8) | OpenCode(2) | Hermes(2) | openai-agents(1)"
  echo ""

  for agent in "${AGENTS[@]}"; do
    model="${MODELS[$agent]}"
    t0=$(date +%s%N)
    
    RESPONSE=$(curl -s -X POST "$API_URL" \
      -H "$AUTH" -H "Content-Type: application/json" \
      -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"Ping: reply OK\"}],\"max_tokens\":5,\"stream\":false}" \
      --connect-timeout 5 --max-time 8 2>/dev/null)
    
    t1=$(date +%s%N)
    RTT_MS=$(( (t1 - t0) / 1000000 ))
    
    STATUS=$(echo "$RESPONSE" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    c = d['choices'][0]['message']['content'][:3]
    print(f'OK({c})')
except:
    print('DOWN')
" 2>/dev/null)
    
    # Color: green for OK, red for DOWN
    if echo "$STATUS" | grep -q "OK"; then
      echo "  ✅ ${agent:15s}  ${model:25s}  ${RTT_MS}ms  ${STATUS}"
    else
      echo "  ❌ ${agent:15s}  ${model:25s}  ${RTT_MS}ms  ${STATUS}"
    fi
  done

  echo ""
  echo "  ↻ Refreshing every 30s...  (Ctrl+C to stop)"
  sleep 30
done
