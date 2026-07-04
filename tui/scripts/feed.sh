#!/bin/bash
# ARES Command Center — Live agent activity feed
# Tails all relevant log sources.

LOG_DIR="$HOME/.hermes/logs"
ARES_DIR="$HOME/autonomous-agent"

echo "═══ ARES AGENT FEED ═══"
echo "Waiting for activity... (no logs yet — feed activates when agents run)"
echo ""

# Try to follow omnigent session logs if they exist
if ls "$ARES_DIR/.omnigent/logs/"* 2>/dev/null; then
  tail -f "$ARES_DIR/.omnigent/logs/"* 2>/dev/null
elif ls "$LOG_DIR"/*.log 2>/dev/null; then
  tail -f "$LOG_DIR"/*.log 2>/dev/null
else
  # Interactive agent monitor: ping each agent periodically
  while true; do
    echo "[$(date '+%H:%M:%S')] ─── Agent Status Poll ───"
    for agent in scout bidder implementer reviewer deliverer financier; do
      STATUS=$(curl -s -X POST http://localhost:20128/v1/chat/completions \
        -H "Authorization: Bearer sk-42e810ef4042e82f-c42dc9-fa0c1bce" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"auto/best-fast\",\"messages\":[{\"role\":\"user\",\"content\":\"Ping\"}],\"max_tokens\":5,\"stream\":false}" \
        --connect-timeout 3 --max-time 5 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['choices'][0]['message']['content'][:30])" 2>/dev/null || echo "DOWN")
      echo "  [$(date '+%H:%M:%S')] ${agent}: ${STATUS}"
    done
    sleep 60
  done
fi
