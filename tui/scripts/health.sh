#!/bin/bash
# ARES Command Center — OmniRoute health + budget + system monitor
# Runs as a continuous refresh loop.

OMNIROUTE_URL="http://localhost:20128"
OMNIROUTE_DB="$HOME/.omniroute/storage.sqlite"

while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║              ARES — AUTONOMOUS REVENUE ENGINE               ║"
  echo "║              Command Center · $(date '+%Y-%m-%d %H:%M:%S')             ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""

  # ── OmniRoute Health ──
  HEALTH=$(curl -s -o /dev/null -w "%{http_code}" "$OMNIROUTE_URL" 2>/dev/null || echo "000")
  if [ "$HEALTH" = "200" ] || [ "$HEALTH" = "404" ]; then
    echo "  🔵 OmniRoute:     ✅ RUNNING  (HTTP 200/404 — gateway live)"
  else
    echo "  🔴 OmniRoute:     ❌ DOWN  (HTTP $HEALTH)"
  fi

  # ── OmniRoute version + uptime ──
  if systemctl is-active omniroute &>/dev/null; then
    UPTIME=$(systemctl show omniroute -p ActiveEnterTimestamp --value 2>/dev/null)
    MEM=$(systemctl show omniroute -p MemoryCurrent --value 2>/dev/null)
    echo "  ⏱  Uptime:        $UPTIME  |  Mem: $((MEM/1024/1024))MB"
  fi

  # ── Budget / Cost (from OmniRoute DB) ──
  if [ -f "$OMNIROUTE_DB" ]; then
    DAILY_COST=$(sqlite3 "$OMNIROUTE_DB" "
      SELECT COALESCE(SUM(total_cost), 0) FROM daily_usage_summary
      WHERE date = date('now','localtime')
    " 2>/dev/null || echo "N/A")
    TOTAL_COST=$(sqlite3 "$OMNIROUTE_DB" "
      SELECT COALESCE(SUM(total_cost), 0) FROM daily_usage_summary
    " 2>/dev/null || echo "N/A")
    echo "  💰 Daily spend:   \$${DAILY_COST}  |  Total all-time: \$${TOTAL_COST}"
    echo "  📊 Budget:        \$5.00/day cap  |  \$3.00 ask threshold"
    # Budget bar
    if [ "$DAILY_COST" != "N/A" ] && [ "$DAILY_COST" != "0" ]; then
      PCT=$(python3 -c "print(min(100, int(float('$DAILY_COST')/5.0*100)))" 2>/dev/null)
      BAR=$(python3 -c "print('█'*int($PCT/5) + '░'*(20-int($PCT/5)))" 2>/dev/null)
      echo "  📈 Budget usage:  [${BAR}] ${PCT}%"
    fi
  else
    echo "  💰 Cost DB:       Not available"
  fi

  # ── System resources ──
  CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
  MEM_TOTAL=$(free -h | awk '/^Mem:/{print $2}')
  MEM_USED=$(free -h | awk '/^Mem:/{print $3}')
  DISK=$(df -h / | awk 'NR==2{print $5}')
  echo "  🖥  System:        CPU ${CPU}%  |  RAM ${MEM_USED}/${MEM_TOTAL}  |  Disk ${DISK}"

  # ── Model TUI quick status ──
  echo ""
  echo "  🔧 model-tui:     $(which model-tui 2>/dev/null || echo 'not installed')"
  echo "  📦 Hermes:        $(hermes --version 2>/dev/null | head -1 || echo 'N/A')"
  echo "  🎯 OpenCode:      $(opencode --version 2>/dev/null | head -1 || echo 'N/A')"
  echo "  🧩 Pi:            $(pi --version 2>/dev/null | head -1 || echo 'N/A')"

  # ── Git status ──
  if [ -d "$HOME/autonomous-agent/.git" ]; then
    BRANCH=$(cd ~/autonomous-agent && git branch --show-current 2>/dev/null)
    COMMITS=$(cd ~/autonomous-agent && git rev-list --count HEAD 2>/dev/null)
    echo "  📁 ares repo:     branch=${BRANCH}  commits=${COMMITS}"
  fi

  # ── Last refresh ──
  echo ""
  echo "  ↻ Refreshing every 10s...  (Ctrl+C to stop)"
  
  sleep 10
done
