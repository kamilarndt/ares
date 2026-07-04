#!/bin/bash
# ARES Command Center — tmux session launcher
# Usage: ares-cmd [kill]
# Uses layout.yaml + layout.py to create the tmux session.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "${1:-}" in
  kill) python3 "$SCRIPT_DIR/layout.py" --kill ;;
  *)    python3 "$SCRIPT_DIR/layout.py" ;;
esac
