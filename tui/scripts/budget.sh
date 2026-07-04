#!/bin/bash
# ARES Command Center — Budget gauge (wide screen)
# Shows budget status, tier progression, cost alerts as horizontal bars.

DB="$HOME/.omniroute/storage.sqlite"

while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║            ARES BUDGET — Self-Funding Loop              ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""

  if [ ! -f "$DB" ]; then
    echo "  ❌ OmniRoute DB not available"
    sleep 15
    continue
  fi

  # Daily cost
  DAILY=$(sqlite3 "$DB" "SELECT COALESCE(SUM(total_cost),0) FROM daily_usage_summary WHERE date=date('now','localtime')" 2>/dev/null)
  TOTAL=$(sqlite3 "$DB" "SELECT COALESCE(SUM(total_cost),0) FROM daily_usage_summary" 2>/dev/null)

  echo "  📊 BUDGET GAUGE"
  echo "  ─────────────────────────────────────────────────────"
  
  CAP=5.0
  ASK=3.0
  
  # Budget bar
  PCT=$(python3 -c "print(min(100, int(float('$DAILY')/$CAP*100)))" 2>/dev/null)
  BAR=$(python3 -c "
pct = $PCT
filled = pct // 5
empty = 20 - filled
color_on = '🟩' if pct < 60 else '🟨' if pct < 80 else '🟥'
bar = color_on * filled + '⬜' * empty
print(bar)
" 2>/dev/null)

  echo "  Used: \$$DAILY / \$$CAP"
  echo "  ${BAR}  ${PCT}%"
  echo ""

  # Ask threshold indicator
  if [ "$(python3 -c "print(float('$DAILY') > $ASK)" 2>/dev/null)" = "True" ]; then
    echo "  ⚠️  ⚠️  ⚠️  OVER ASK THRESHOLD (\$$ASK) — council debate required!"
  else
    REMAIN=$(python3 -c "print(max(0, $ASK - float('$DAILY')))" 2>/dev/null)
    echo "  ✅ Under ask threshold (\$$ASK). \$${REMAIN} until warning."
  fi

  # Hard cap check
  if [ "$(python3 -c "print(float('$DAILY') >= $CAP)" 2>/dev/null)" = "True" ]; then
    echo "  🚫 🚫 🚫  HARD CAP REACHED — pausing T3/T4 agents!"
  fi

  echo ""
  echo "  📈 TIER PROGRESSION"
  echo "  ─────────────────────────────────────────────────────"
  echo "  Daily net profit targets:"
  echo "  BOOTSTRAP (\$0/d)     ████████████████████  ← current"
  echo "  EARNING (\$3/d)       ░░░░░░░░░░░░░░░░░░░░"
  echo "  PROFITABLE (\$15/d)   ░░░░░░░░░░░░░░░░░░░░"
  echo "  SCALE (\$50/d)        ░░░░░░░░░░░░░░░░░░░░"

  echo ""
  echo "  💰 TOTAL ALL-TIME SPEND: \$$TOTAL"
  echo "  📅 Date: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "  ↻ Refreshing every 10s..."
  
  sleep 10
done
