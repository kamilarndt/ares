#!/bin/bash
# ARES Command Center — OmniRoute health + system monitor (wide)

OMNIROUTE_URL="http://localhost:20128"
OMNIROUTE_DB="$HOME/.omniroute/storage.sqlite"

while true; do
  clear
  # Single-line header (wide optimized)
  HEALTH=$(curl -s -o /dev/null -w "%{http_code}" "$OMNIROUTE_URL" 2>/dev/null || echo "000")
  OMNI_STATUS="🔴 DOWN"
  [ "$HEALTH" = "200" ] || [ "$HEALTH" = "404" ] && OMNI_STATUS="✅ RUNNING"

  # System stats one-liner
  CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' 2>/dev/null || echo "?")
  MEM_TOTAL=$(free -h | awk '/^Mem:/{print $2}' 2>/dev/null || echo "?")
  MEM_USED=$(free -h | awk '/^Mem:/{print $3}' 2>/dev/null || echo "?")
  DISK=$(df -h / | awk 'NR==2{print $5}' 2>/dev/null || echo "?")
  UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' || echo "?")

  if systemctl is-active omniroute &>/dev/null; then
    OMNI_MEM=$(systemctl show omniroute -p MemoryCurrent --value 2>/dev/null)
    OMNI_MEM_MB=$((OMNI_MEM/1024/1024))
  else
    OMNI_MEM_MB="?"
  fi

  echo "╔══════════════════════════════════════════════════════════════════════╗"
  echo "║                        ARES SYSTEM DASHBOARD                        ║"
  echo "║  $(date '+%Y-%m-%d %H:%M:%S')                                           ║"
  echo "╚══════════════════════════════════════════════════════════════════════╝"
  echo ""
  
  # Two-column layout for wide screens
  echo "  ┌─────────────────────────────────┬─────────────────────────────────┐"
  printf "  │  %-31s │  %-31s │\n" "OmniRoute: ${OMNI_STATUS}" "CPU: ${CPU}%"
  printf "  │  %-31s │  %-31s │\n" "Memory: ${OMNI_MEM_MB}MB" "RAM: ${MEM_USED}/${MEM_TOTAL}"
  printf "  │  %-31s │  %-31s │\n" "Uptime: ${UPTIME}" "Disk: ${DISK}"
  echo "  └─────────────────────────────────┴─────────────────────────────────┘"
  echo ""

  # Tools status
  echo "  ┌──────────────────────────────────────────────────────────────────┐"
  echo "  │  TOOLS                                                          │"
  echo "  ├──────────────────────────────────────────────────────────────────┤"
  for tool in "opencode" "pi" "hermes" "model-tui" "bwrap"; do
    PATH=$(which $tool 2>/dev/null)
    if [ -n "$PATH" ]; then
      VER=$($tool --version 2>/dev/null | head -1)
      printf "  │  ✅ %-15s │ %s\n" "$tool" "${VER:-$PATH}"
    else
      printf "  │  ❌ %-15s │ not installed\n" "$tool"
    fi
  done
  echo "  └──────────────────────────────────────────────────────────────────┘"
  echo ""

  # Git status
  if [ -d "$HOME/autonomous-agent/.git" ]; then
    BRANCH=$(cd ~/autonomous-agent && git branch --show-current 2>/dev/null)
    COMMITS=$(cd ~/autonomous-agent && git rev-list --count HEAD 2>/dev/null)
    LAST=$(cd ~/autonomous-agent && git log --oneline -1 2>/dev/null)
    DIRTY=$(cd ~/autonomous-agent && git status --short 2>/dev/null | wc -l)
    echo "  📁 ares repo:  ${BRANCH}  |  ${COMMITS} commits  |  ${DIRTY} dirty files  |  last: ${LAST}"
  fi

  echo ""
  echo "  🔄 Refreshing every 5s..."
  sleep 5
done
