#!/bin/bash
# ARES Command Center — prosty, 4 okna, tylko to co ważne
# Usage: ares-cmd (create/attach)   ares-cmd kill

SESSION="ares-cmd"
SCRIPTS="$HOME/autonomous-agent/tui/scripts"

kill_session() {
  tmux kill-session -t "$SESSION" 2>/dev/null
  echo "✅ Session killed."
  exit 0
}
[ "$1" = "kill" ] && kill_session

tmux kill-session -t "$SESSION" 2>/dev/null

# ── Window 0: STATUS — wszystko na jednym ekranie ──
tmux new-session -d -s "$SESSION" -n "status"
tmux send-keys -t "$SESSION:0.0" "$SCRIPTS/status.sh" Enter

# ── Window 1: LOGS — aktywność agentów ──
tmux new-window -t "$SESSION" -n "logs"
tmux send-keys -t "$SESSION:1.0" "$SCRIPTS/logs.sh" Enter

# ── Window 2: SHELL — terminal do roboty ──
tmux new-window -t "$SESSION" -n "shell"
tmux send-keys -t "$SESSION:2.0" "cd ~/autonomous-agent && echo '🐚 ARES Shell — tu uruchamiasz agentów'; echo ''; echo '  quick commands:'; echo '    omnigent run config.yaml --prompt ...'; echo '    git status'; echo '    systemctl status omniroute'; echo ''" Enter

# ── Window 3: MODEL-TUI ──
tmux new-window -t "$SESSION" -n "model-tui"
tmux send-keys -t "$SESSION:3.0" "model-tui 2>/dev/null || echo 'model-tui not installed'; bash" Enter

# ── Status bar — czysty ──
tmux set-option -t "$SESSION" -g status-left "#[fg=green]🐺 ARES #[fg=white]|"
tmux set-option -t "$SESSION" -g status-right "#[fg=yellow]%Y-%m-%d %H:%M:%S #[fg=white]| #[fg=cyan]#(curl -s -o /dev/null -w '%{http_code}' -H 'Authorization: Bearer sk-42e810ef4042e82f-c42dc9-fa0c1bce' http://localhost:20128/api/v1/models 2>/dev/null || echo 'DOWN')#[fg=white] OmniRoute"
tmux set-option -t "$SESSION" -g status-interval 5
tmux set-option -t "$SESSION" -g window-status-current-style "bg=blue,fg=white"
tmux set-option -t "$SESSION" -g window-status-format " #I:#W "
tmux set-option -t "$SESSION" -g window-status-current-format " #I:#W "
tmux set-option -t "$SESSION" -g status-left-length 20

tmux select-window -t "$SESSION:0"

if [ -z "$TMUX" ]; then
  tmux attach-session -t "$SESSION"
else
  echo "✅ ARES Command Center — 4 windows"
  echo "  0 status    — podgląd wszystkiego"
  echo "  1 logs      — aktywność agentów"
  echo "  2 shell     — terminal do roboty"
  echo "  3 model-tui — monitoring modeli"
  echo ""
  echo "  attach: tmux attach -t $SESSION"
  echo "  kill:   ares-cmd kill"
fi
