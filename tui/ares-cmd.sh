#!/bin/bash
# ARES Command Center — tmux session launcher (wide screen optimized)
# Usage: ares-cmd              (create/attach)
#        ares-cmd kill         (kill session)

SESSION="ares-cmd"
SCRIPTS="$HOME/autonomous-agent/tui/scripts"

kill_session() {
  tmux kill-session -t "$SESSION" 2>/dev/null
  echo "Session '$SESSION' killed."
  exit 0
}

if [ "$1" = "kill" ]; then kill_session; fi

# Kill existing
tmux kill-session -t "$SESSION" 2>/dev/null

# ── Window 0: Dashboard — WIDE LAYOUT ──
# Top row: 3 columns (Health | Cost | Budget)
# Bottom:  1 row full-width (Agent Feed)
tmux new-session -d -s "$SESSION" -n "dashboard" -x 240 -y 65

# Pane 0.0: Health (top-left)
tmux send-keys -t "$SESSION:0.0" "watch -n 5 '$SCRIPTS/health.sh 2>/dev/null || echo waiting...'" Enter

# Pane 0.1: Cost (top-center)
tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "watch -n 10 '$SCRIPTS/cost.sh 2>/dev/null || echo waiting...'" Enter

# Pane 0.2: Budget (top-right)
tmux split-window -h -t "$SESSION:0.1"
tmux send-keys -t "$SESSION:0.2" "watch -n 10 '$SCRIPTS/budget.sh 2>/dev/null || echo waiting...'" Enter

# Pane 0.3: Feed (full-width bottom)
tmux select-pane -t "$SESSION:0.0"
tmux split-window -v -t "$SESSION:0.0"
tmux send-keys -t "$SESSION:0.3" "$SCRIPTS/feed.sh" Enter

# ── Window 1: Agents — WIDE GRID (3 cols × 4 rows) ──
tmux new-window -t "$SESSION" -n "agents"
tmux send-keys -t "$SESSION:1.0" "watch -n 30 '$SCRIPTS/agents.sh 2>/dev/null || echo waiting...'" Enter

# ── Window 2: Control — WIDE (git left, cmds right) ──
tmux new-window -t "$SESSION" -n "control"
# Split into two columns
tmux split-window -h -t "$SESSION:2"
tmux send-keys -t "$SESSION:2.0" "watch -n 15 '$SCRIPTS/control.sh 2>/dev/null || echo waiting...'" Enter
tmux send-keys -t "$SESSION:2.1" "cd ~/autonomous-agent && echo 'Quick Commands:'; echo '  ares-cmd         — restart center'; echo '  tmux attach -t ares-cmd — reattach'; echo '  docker compose up -d  — start ARES'; echo '  omnigent run config.yaml — run ARES'; echo '  systemctl status omniroute — gateway'; echo '  tail -f ~/.hermes/logs/*.log — debug'; echo ''; echo '─── Quick Action Buttons ───'; echo '  [1] Restart OmniRoute'; echo '  [2] Show cost DB'; echo '  [3] Git push'; echo ''; exec bash" Enter

# ── Window 3: model-tui ──
tmux new-window -t "$SESSION" -n "model-tui"
tmux send-keys -t "$SESSION:3.0" "model-tui 2>/dev/null || echo 'model-tui not available'; bash" Enter

# ── Window 4: ARES Run ──
tmux new-window -t "$SESSION" -n "ares-run"
tmux send-keys -t "$SESSION:4.0" "cd ~/autonomous-agent && echo 'ARES Runtime — run agents here'; echo '  omnigent run config.yaml'; echo ''" Enter

# ── Window 5: Shell ──
tmux new-window -t "$SESSION" -n "shell"
tmux send-keys -t "$SESSION:5.0" "cd ~/autonomous-agent && echo 'ARES Shell — ad-hoc commands'; echo ''" Enter

# ── Status bar — wide optimized ──
tmux set-option -t "$SESSION" -g status-left "#[fg=green]🐺 ARES CMD #[fg=white]|"
tmux set-option -t "$SESSION" -g status-right "#[fg=yellow]%Y-%m-%d %H:%M:%S #[fg=white]| #[fg=cyan]#(curl -s -o /dev/null -w '%{http_code}' -H 'Authorization: Bearer sk-42e810ef4042e82f-c42dc9-fa0c1bce' http://localhost:20128/api/v1/models 2>/dev/null || echo 'DOWN')#[fg=white] OmniRoute #[fg=white]| #[fg=magenta]#(python3 -c \"import sqlite3; db='/root/.omniroute/storage.sqlite'; c=sqlite3.connect(db); d=c.execute('SELECT COALESCE(SUM(total_cost),0) FROM daily_usage_summary WHERE date=date(\\\"now\\\",\\\"localtime\\\")').fetchone()[0]; c.close(); print(f'\\\${d:.2f}')\" 2>/dev/null || echo '\$?')#[fg=white] today"
tmux set-option -t "$SESSION" -g status-interval 5
tmux set-option -t "$SESSION" -g status-left-length 30
tmux set-option -t "$SESSION" -g window-status-current-style "bg=blue,fg=white"
tmux set-option -t "$SESSION" -g window-status-format " #I:#W "
tmux set-option -t "$SESSION" -g window-status-current-format " #I:#W "

# ── Select first window ──
tmux select-window -t "$SESSION:0"
tmux select-pane -t "$SESSION:0.0"

# ── Attach ──
if [ -z "$TMUX" ]; then
  tmux attach-session -t "$SESSION"
else
  echo "✅ ARES Command Center (wide) started in session '$SESSION'"
  echo ""
  echo "  Windows:"
  echo "    0 dashboard  — Health | Cost | Budget (top) + Feed (bottom)"
  echo "    1 agents     — 12-agent wide grid"
  echo "    2 control    — Git (left) + Quick commands (right)"
  echo "    3 model-tui  — Model/token live monitoring"
  echo "    4 ares-run   — Launch ARES agents"
  echo "    5 shell      — Ad-hoc terminal"
  echo ""
  echo "  Attach: tmux attach -t $SESSION"
  echo "  Kill:   ares-cmd kill"
fi
