#!/bin/bash
# ARES Command Center — teamocil launcher
# Usage: ares-cmd              (create/attach)
#        ares-cmd kill         (kill session)

SESSION="ares-cmd"
LAYOUT="$HOME/autonomous-agent/tui/layout-teamocil.yml"

if [ "$1" = "kill" ]; then
  tmux kill-session -t "$SESSION" 2>/dev/null
  for s in $(tmux ls 2>/dev/null | grep teamocil-session | cut -d: -f1); do
    tmux kill-session -t "$s" 2>/dev/null
  done
  echo "✅ Session killed."
  exit 0
fi

# Clean up old sessions
tmux kill-session -t "$SESSION" 2>/dev/null
for s in $(tmux ls 2>/dev/null | grep teamocil-session | cut -d: -f1); do
  tmux kill-session -t "$s" 2>/dev/null
done

# Create temp session, run teamocil inside
tmux new-session -d -s "$SESSION" -n "init" -c "$HOME/autonomous-agent"
tmux send-keys -t "$SESSION:0" "teamocil --layout '$LAYOUT' 2>&1; tmux kill-window -t init 2>/dev/null" Enter
sleep 3

# Find the actual teamocil session (teamocil renames sessions)
SESS=$(tmux ls 2>/dev/null | grep teamocil-session | tail -1 | cut -d: -f1)
if [ -n "$SESS" ]; then
  tmux kill-window -t "$SESS:init" 2>/dev/null
  tmux select-window -t "$SESS:status" 2>/dev/null || true
  if [ -z "$TMUX" ]; then
    tmux attach-session -t "$SESS"
  else
    echo "✅ ARES Command Center — 3 windows"
    echo "  0 status     — dashboard + logs"
    echo "  1 shell      — terminal"
    echo "  2 model-tui  — model monitoring"
  fi
else
  # Fallback
  python3 "$HOME/autonomous-agent/tui/layout.py"
fi
