#!/bin/bash
# ARES Command Center — Real-time cost monitor
# Reads from OmniRoute SQLite DB with periodic updates.

DB="$HOME/.omniroute/storage.sqlite"
API_KEY="sk-42e810ef4042e82f-c42dc9-fa0c1bce"

while true; do
  clear
  echo "╔══════════════════════════════════════╗"
  echo "║      ARES — COST & BUDGET MONITOR    ║"
  echo "║      $(date '+%Y-%m-%d %H:%M:%S')        ║"
  echo "╚══════════════════════════════════════╝"
  echo ""

  # ── Daily cost ──
  if [ -f "$DB" ]; then
    echo "  📊 DAILY USAGE"
    echo "  ────────────────────────────────────"
    sqlite3 "$DB" -header -column "
      SELECT 
        date,
        ROUND(total_cost, 4) AS cost,
        total_tokens AS tokens,
        total_requests AS reqs
      FROM daily_usage_summary
      ORDER BY date DESC
      LIMIT 7;
    " 2>/dev/null
    echo ""
    
    # Per-provider breakdown (today)
    echo "  🏢 TODAY BY PROVIDER"
    echo "  ────────────────────────────────────"
    sqlite3 "$DB" -header -column "
      SELECT 
        provider,
        ROUND(SUM(total_cost), 4) AS cost,
        SUM(total_tokens) AS tokens,
        SUM(total_requests) AS reqs
      FROM usage_history
      WHERE date = date('now','localtime')
      GROUP BY provider
      ORDER BY cost DESC;
    " 2>/dev/null
    echo ""
    
    # Budget gauge
    DAILY=$(sqlite3 "$DB" "SELECT COALESCE(SUM(total_cost),0) FROM daily_usage_summary WHERE date=date('now','localtime');" 2>/dev/null)
    if [ -n "$DAILY" ]; then
      PCT=$(python3 -c "print(min(100, int(float('$DAILY')/5.0*100)))" 2>/dev/null)
      BAR=$(python3 -c "b='█'*int($PCT/5); b+='░'*(20-len(b)); print(b)" 2>/dev/null)
      echo "  💰 Budget: \$5.00/day"
      echo "     [${BAR}] \$${DAILY} used (${PCT}%)"
      
      if [ "$(python3 -c "print(float('$DAILY') > 3.0)" 2>/dev/null)" = "True" ]; then
        echo "  ⚠️  WARNING: Over \$3.00 ask threshold!"
      fi
      if [ "$(python3 -c "print(float('$DAILY') > 5.0)" 2>/dev/null)" = "True" ]; then
        echo "  🚫 HARD CAP REACHED!"
      fi
    fi
  else
    echo "  ❌ OmniRoute DB not found at $DB"
  fi

  # ── Active models via API ──
  echo ""
  echo "  🔄 ACTIVE AUTO-ROUTERS"
  echo "  ────────────────────────────────────"
  curl -s -H "Authorization: Bearer $API_KEY" \
    http://localhost:20128/api/v1/models 2>/dev/null | \
    python3 -c "
import sys, json
d = json.load(sys.stdin)
for m in d.get('data', []):
    if m['id'].startswith('auto/'):
        print(f\"    {m['id']:30s} ctx={m.get('context_length','?'):>7s}\")
" 2>/dev/null

  sleep 15
done
