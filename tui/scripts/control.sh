#!/bin/bash
# ARES Command Center — Git watcher + quick command panel

while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║              ARES — COMMAND PANEL                        ║"
  echo "║              $(date '+%Y-%m-%d %H:%M:%S')               ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""

  # ── Git Status ──
  echo "  📂 GIT STATUS  (autonomous-agent)"
  echo "  ──────────────────────────────────────────────────────"
  if [ -d "$HOME/autonomous-agent/.git" ]; then
    cd "$HOME/autonomous-agent"
    echo "  Branch: $(git branch --show-current 2>/dev/null)"
    echo "  Remote: $(git remote -v 2>/dev/null | head -2)"
    echo "  Status:"
    git status --short 2>/dev/null | head -20
    if [ -z "$(git status --short)" ]; then
      echo "    ✅ Clean working tree"
    fi
    echo ""
    echo "  Last commit: $(git log --oneline -1 2>/dev/null)"
  else
    echo "    Not a git repository"
  fi

  # ── Agent Config Status ──
  echo ""
  echo "  ⚙️  AGENT CONFIG HEALTH"
  echo "  ──────────────────────────────────────────────────────"
  echo "  Configs: $(ls $HOME/autonomous-agent/agents/*/config.yaml 2>/dev/null | wc -l) agent files"
  echo "  Harness types:"
  for f in $HOME/autonomous-agent/agents/*/config.yaml; do
    name=$(basename $(dirname "$f"))
    harness=$(grep -A1 "harness:" "$f" 2>/dev/null | tail -1 | awk '{print $2}')
    echo "    ${name:20s} → ${harness}"
  done 2>/dev/null

  echo ""
  echo "  📋 QUICK COMMANDS"
  echo "  ──────────────────────────────────────────────────────"
  echo "    Ctrl+b c   — Create new window"
  echo "    Ctrl+b n/p — Next/Previous window"
  echo "    Ctrl+b d   — Detach session"
  echo "    Ctrl+b [   — Scroll mode (q to quit)"
  echo "    Ctrl+b %   — Vertical split"
  echo "    Ctrl+b \"   — Horizontal split"
  
  # ── Windows ──
  echo ""
  echo "  🪟 WINDOWS: 0=dashboard  1=agents  2=cost  3=control  4=model-tui"
  echo ""
  
  echo "  ↻ Refreshing every 15s..."
  sleep 15
done
