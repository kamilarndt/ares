#!/bin/bash
# ARES Command Center — jeden ekran, wszystko co ważne
# Łączy health + cost + budget + agents w jeden widok.

OMNIROUTE_URL="http://localhost:20128"
AUTH="Authorization: Bearer sk-42e810ef4042e82f-c42dc9-fa0c1bce"
OMNIROUTE_DB="$HOME/.omniroute/storage.sqlite"
ARES_DIR="$HOME/autonomous-agent"

AGENTS=(
  "scout|pi"
  "bidder|pi"
  "implementer|opencode"
  "reviewer|pi"
  "deliverer|pi"
  "financier|pi"
  "sdr-promoter|hermes"
  "aeo-architect|opencode"
  "prediction-trader|pi"
  "council|pi"
  "insight-engine|hermes"
  "war-room|pi"
)

CACHE_FILE="/tmp/ares-agent-cache.txt"

while true; do
  clear

  # ── Header ──
  echo "╔════════════════════════════════════════════════════════════════════╗"
  echo "║  🐺  A R E S   C O M M A N D   C E N T E R     $(date '+%Y-%m-%d %H:%M:%S')  ║"
  echo "╚════════════════════════════════════════════════════════════════════╝"
  echo ""

  # ── Row 1: SYSTEM + AGENTS ──
  # System info (left)
  HEALTH=$(curl -s -o /dev/null -w "%{http_code}" -H "$AUTH" "$OMNIROUTE_URL/api/v1/models" 2>/dev/null || echo "000")
  OMNI_STATUS="🔴 DOWN"
  [ "$HEALTH" = "200" ] && OMNI_STATUS="✅ LIVE"

  CPU=$(top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{print int($2)}' 2>/dev/null || echo "?")
  MEM_TOTAL=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}' || echo "?")
  MEM_USED=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}' || echo "?")

  if [ -d "$ARES_DIR/.git" ]; then
    cd "$ARES_DIR"
    BRANCH=$(git branch --show-current 2>/dev/null || echo "?")
    COMMITS=$(git rev-list --count HEAD 2>/dev/null || "?")
    DIRTY=$(git status --short 2>/dev/null | wc -l)
    GIT_INFO="${BRANCH} (${COMMITS} commits, ${DIRTY} dirty)"
    cd - &>/dev/null
  else
    GIT_INFO="no repo"
  fi

  # Agent status (right) — ping all 12 in parallel for speed
  ALIVE=0
  AGENT_LINES=()
  idx=0
  for agent_def in "${AGENTS[@]}"; do
    IFS='|' read -r name harness <<< "$agent_def"
    t0=$(date +%s%N)
    RESP=$(curl -s -X POST "$OMNIROUTE_URL/v1/chat/completions" \
      -H "$AUTH" -H "Content-Type: application/json" \
      -d "{\"model\":\"auto/best-fast\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":2,\"stream\":false}" \
      --connect-timeout 3 --max-time 5 2>/dev/null)
    t1=$(date +%s%N)
    RTT=$(( (t1 - t0) / 1000000 ))
    OK=$(echo "$RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print('1')" 2>/dev/null || echo "0")
    if [ "$OK" = "1" ]; then
      ((ALIVE++))
      AGENT_LINES+=("$(printf "%-4s" "$name") ✅ ${RTT}ms")
    else
      AGENT_LINES+=("$(printf "%-4s" "$name") ❌ --")
    fi
  done

  # Display SYSTEM (left) and AGENTS (right) side by side
  echo "  ┌────────── SYSTEM ──────────┐   ┌────────── AGENTS (${ALIVE}/12) ─────────┐"
  printf "  │  OmniRoute: %-18s │   │  %-18s %-18s │\n" "$OMNI_STATUS" "${AGENT_LINES[0]}" "${AGENT_LINES[1]}"
  printf "  │  CPU: %-22s │   │  %-18s %-18s │\n" "${CPU}% · RAM ${MEM_USED}/${MEM_TOTAL}" "${AGENT_LINES[2]}" "${AGENT_LINES[3]}"
  printf "  │  Repo: %-20s │   │  %-18s %-18s │\n" "$GIT_INFO" "${AGENT_LINES[4]}" "${AGENT_LINES[5]}"
  echo "  │                          │   │                                        │"
  # Second row of agents
  printf "  │  $(date '+%H:%M:%S')%-9s │   │  %-18s %-18s │\n" "" "${AGENT_LINES[6]}" "${AGENT_LINES[7]}"
  printf "  │                          │   │  %-18s %-18s │\n" "" "${AGENT_LINES[8]}" "${AGENT_LINES[9]}"
  printf "  │                          │   │  %-18s %-18s │\n" "" "${AGENT_LINES[10]}" "${AGENT_LINES[11]}"
  echo "  └──────────────────────────┘   └────────────────────────────────────┘"
  echo ""

  # ── Row 2: BUDGET + TOOLS ──
  # Budget
  if [ -f "$OMNIROUTE_DB" ]; then
    DAILY=$(sqlite3 "$OMNIROUTE_DB" "SELECT COALESCE(ROUND(SUM(total_cost),2),0) FROM daily_usage_summary WHERE date=date('now','localtime')" 2>/dev/null)
    PCT=$(python3 -c "print(min(100, int(float('$DAILY')/5.0*100)))" 2>/dev/null)
    BAR=$(python3 -c "a='█'*int($PCT/5); a+='░'*(20-len(a)); print(a)" 2>/dev/null)
  else
    DAILY="?";
    PCT=0;
    BAR="░░░░░░░░░░░░░░░░░░░░"
  fi

  echo "  ┌────────── BUDGET ──────────┐   ┌────────── TOOLS ──────────┐"
  echo "  │  Today: \$$DAILY / \$5.00     │   │  $(command -v opencode && echo '✅' || echo '❌') opencode    $(command -v pi && echo '✅' || echo '❌') pi        │"
  echo "  │  ${BAR} ${PCT}%  │   │  $(command -v hermes && echo '✅' || echo '❌') hermes   $(command -v model-tui && echo '✅' || echo '❌') model-tui │"
  echo "  │  Status: $(python3 -c "print('⚠️ OVER ASK' if float('$DAILY')>3 else '✅ under')" 2>/dev/null)      │   │  $(command -v bwrap && echo '✅' || echo '❌') bwrap    $(command -v tmux && echo '✅' || echo '❌') tmux     │"
  echo "  └──────────────────────────┘   └────────────────────────────┘"
  echo ""

  # ── Footer ──
  echo "  Windows: 0=status  1=logs  2=shell  3=model-tui   |   Ctrl+b <nr>"
  echo "  ↻ Refresh: every 15s  |  ares-cmd kill — stop"
  sleep 15
done
