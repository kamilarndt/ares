#!/bin/bash
# ARES Command Center — 12-Agent Status Grid (wide optimized)

API_URL="http://localhost:20128/v1/chat/completions"
AUTH="Authorization: Bearer sk-42e810ef4042e82f-c42dc9-fa0c1bce"

# Agent definitions: name|model|harness
AGENTS=(
  "scout|auto/best-fast|pi"
  "bidder|auto/best-chat|pi"
  "implementer|auto/best-coding|opencode"
  "reviewer|auto/best-reasoning|pi"
  "deliverer|auto/best-fast|pi"
  "financier|auto/best-reasoning|pi"
  "sdr-promoter|auto/best-chat|hermes"
  "aeo-architect|auto/best-coding|opencode"
  "prediction-trader|auto/best-reasoning|pi"
  "council|auto/best-reasoning|pi"
  "insight-engine|auto/best-reasoning|hermes"
  "war-room|auto/best-reasoning|pi"
)

while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════════════════════════════════════╗"
  echo "║                              ARES — 12-AGENT STATUS                                    ║"
  echo "║  $(date '+%Y-%m-%d %H:%M:%S')    Pi(8) | OpenCode(2) | Hermes(2)                          ║"
  echo "╚══════════════════════════════════════════════════════════════════════════════════════════╝"
  echo ""

  # Table header
  printf "  %-2s  %-18s %-28s %-10s %-8s %s\n" "" "AGENT" "MODEL" "HARNESS" "STATUS" "RTT"
  echo "  ──────────────────────────────────────────────────────────────────────────────────────────"

  for agent_def in "${AGENTS[@]}"; do
    IFS='|' read -r name model harness <<< "$agent_def"
    
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
    c = d['choices'][0]['message']['content']
    print('OK')
except:
    print('DOWN')
" 2>/dev/null)

    if [ "$STATUS" = "OK" ]; then
      echo -e "  ✅  ${name}\t\t${model}\t${harness}\tOK\t${RTT_MS}ms"
    else
      echo -e "  ❌  ${name}\t\t${model}\t${harness}\tDOWN\t${RTT_MS}ms"
    fi
  done

  echo ""
  echo "  ↻ Refreshing every 30s...  (Ctrl+C to stop)"
  sleep 30
done
