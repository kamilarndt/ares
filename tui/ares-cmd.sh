#!/bin/bash
# ARES Command Center — tmux session launcher
# Usage: ares-cmd              (create/attach)
#        ares-cmd kill         (kill session)

SESSION="ares-cmd"
SCRIPTS="$HOME/autonomous-agent/tui/scripts"
API_KEY="sk-42e810ef4042e82f-c42dc9-fa0c1bce"

kill_session() {
  tmux kill-session -t "$SESSION" 2>/dev/null
  echo "Session '$SESSION' killed."
  exit 0
}

if [ "$1" = "kill" ]; then kill_session; fi

# Kill existing
tmux kill-session -t "$SESSION" 2>/dev/null

# ── Window 0: Dashboard (3 panes) ──
tmux new-session -d -s "$SESSION" -n "dashboard" -x 180 -y 50

# Pane 0.0: Health (top-left)
tmux send-keys -t "$SESSION:0.0" "watch -n 5 '$SCRIPTS/health.sh 2>/dev/null || echo waiting...'" Enter

# Pane 0.1: Cost (top-right)
tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "watch -n 10 '$SCRIPTS/cost.sh 2>/dev/null || echo waiting...'" Enter

# Pane 0.2: Feed (bottom)
tmux split-window -v -t "$SESSION:0.0"
tmux send-keys -t "$SESSION:0.2" "$SCRIPTS/feed.sh" Enter

# ── Window 1: Agents Grid ──
tmux new-window -t "$SESSION" -n "agents"
tmux send-keys -t "$SESSION:1.0" "watch -n 30 '$SCRIPTS/agents.sh 2>/dev/null || echo waiting...'" Enter

# ── Window 2: Control Panel ──
tmux new-window -t "$SESSION" -n "control"
tmux send-keys -t "$SESSION:2.0" "watch -n 15 '$SCRIPTS/control.sh 2>/dev/null || echo waiting...'" Enter

# ── Window 3: model-tui ──
tmux new-window -t "$SESSION" -n "model-tui"
tmux send-keys -t "$SESSION:3.0" "model-tui 2>/dev/null || echo 'model-tui not available'; bash" Enter

# ── Window 4: Shell ──
tmux new-window -t "$SESSION" -n "shell"
tmux send-keys -t "$SESSION:4.0" "cd ~/autonomous-agent && echo 'ARES Shell — ready'; echo 'Quick commands: git status, docker ps, systemctl status omniroute'" Enter

# ── Status bar ──
tmux set-option -t "$SESSION" -g status-left "#[fg=green]#S #[fg=white]|"
tmux set-option -t "$SESSION" -g status-right "#[fg=yellow]%Y-%m-%d %H:%M:%S#[fg=white] | #[fg=cyan]#(curl -s -o /dev/null -w '%{http_code}' http://localhost:20128 2>/dev/null || echo 'DOWN')#[fg=white] OmniRoute"
tmux set-option -t "$SESSION" -g status-interval 5
tmux set-option -t "$SESSION" -g window-status-current-style "bg=blue,fg=white"

# ── Select first window ──
tmux select-window -t "$SESSION:0"

# ── Attach ──
if [ -z "$TMUX" ]; then
  tmux attach-session -t "$SESSION"
else
  echo "✅ ARES Command Center started in session '$SESSION'"
  echo ""
  echo "  Windows:"
  echo "    0 dashboard  — health + cost + feed"
  echo "    1 agents     — 12-agent status grid"
  echo "    2 control    — git + config + commands"
  echo "    3 model-tui  — model/token monitoring"
  echo "    4 shell      — ad-hoc terminal"
  echo ""
  echo "  Attach: tmux attach -t $SESSION"
  echo "  Kill:   ares-cmd kill"
fi
